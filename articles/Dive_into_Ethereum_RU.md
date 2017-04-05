# Dive into Ethereum

Хайп вокруг технологии **"blockchain"** растет с экспоненциалной скоростью. В этом можно убедиться, как пролистав ленты популярных новостных агенств или открыв Google Trends, так и посмотрев на курсы  криптовалют и капитализации отдельных компаний. Одновременно с этим для обычного пользователя вся эта шумиха продолжает оставаться чем-то загадочным и непонятным (что совершенно нормально!). Другое дело, что большинство разработчиков точно также упорно не понимают, о чем вся эта _цепочка блоков_ и есть ли от нее толк на практике?

В этой статье я постараюсь продемонстрировать работу с технологией блокчейн на масимально приближенном к реальности примере: с помощью платформы Ethereum мы создадим приложение наподобие сайта-визитной карточки, а параллельно с этим я постарюсь рассказать вам про разные инструменты и тонкости в разработке такого рода.

![preview](https://habrastorage.org/files/f65/dce/6d0/f65dce6d013a4f579c947bcc49f4013a.png)

## Содержание

## Введение в Ethereum
Эта статья не расчитана на тех, кто совсем не знаком с Ethereum, поэтому объяснений базовых вещей вроде *блоков*, *транзакций* или *контрактов* здесь не будет. Вместо это я подразумеваю, что вы хотя бы чуть-чуть в курсе происходящего. В противном случае полистайте статьи из списка ниже, а потом возвращайтесь :)

- [RU - Пишем умный контракт на Solidity. Часть 1 — установка и «Hello world»](https://habrahabr.ru/post/312008/)
- [RU - Malware + Blockchain = ❤️](https://habrahabr.ru/post/313710/)
- [RU - Как мы делали первую сделку-аккредитив на блокчейн в Альфа-Банке](https://habrahabr.ru/company/alfa/blog/323070/)
- [EN - A 101 Noob Intro to Programming Smart Contracts on Ethereum](http://consensys.github.io/developers/articles/101-noob-intro/)
- [EN - Ethereum for web developers](https://medium.com/@mvmurthy/ethereum-for-web-developers-890be23d1d0c)
- [EN - Building a smart contract using the command line](https://www.ethereum.org/greeter)
- [EN - Create your own crypto-currency](https://www.ethereum.org/token)
- [EN - Dapps for Beginners](https://dappsforbeginners.wordpress.com/)
- [EN - A 101 Noob Intro to Programming Smart Contracts on Ethereum](http://consensys.github.io/developers/articles/101-noob-intro/)

Больше ссылок на интересные статьи вы найдете в конце.

**P.S.** Я работаю под Ubuntu 16.04, так что весь процесс установки, разработки и деплоя будет описан под эту ОС. Тем не менее все используемые инструменты кроссплатформенны (не проверял), так что при желании можете поэкспериментировать на других ОС.

## Инструменты

### [Geth](https://ethereum.github.io/go-ethereum/)

Работа с Ethereum возможна через огромное число клиентов, часть из которых terminal-based, часть GUI и есть несколько гибридных решений. Своего рода стандартом является [Geth](), который разрабатывается самой командой Ethereum. Про него я уже писал в [предыдущих статьях](https://habrahabr.ru/post/312008/), но в этой статье мы будем пользоваться именно им, поэтому на всякий случай повторюсь.

Клиент написан на Go, устанавливается [стандартным способом](https://www.ethereum.org/cli):

```bash
sudo apt-get install software-properties-common
sudo add-apt-repository -y ppa:ethereum/ethereum
sudo apt-get update
sudo apt-get install ethereum
```

Сам Geth не имеет GUI, но работать с ним из терминала довольно приятно. [Здесь](https://github.com/ethereum/go-ethereum/wiki/Command-Line-Options) описан весь набор аргументов командной строки, я же опишу несколько самых популярных.

Вот команда, которую я чаще всего использую в работе: `geth --dev --rpc --rpcaddr "0.0.0.0" --rpcapi "admin,debug,miner,shh,txpool,personal,eth,net,web3" console`

- `--dev` запускает geth в режиме приватного блокчейна, то есть не синхронизирет основную / тестовую ветку. Вместо этого вы получаете стерильную цепочку без единого блока. Это самый удобный вариант в плане разработки, так как, например, майнинг блока занимает несколько секунд и нет никакой нагрузки на сеть или диск.

- `--rpc` включает RPC-HTTP сервер. По сути это API к вашей ноде - через него сторонние приложения, вроде кошельков или IDE, смогут работать с блокчейном: загружать контракты, отправлять транзакции и так далее. По дефолту запускается на [localhost:8545](http://localhost:8545), можете изменить эти параметры с помощью `--rpcaddr` и `--rpcport` соответственно.
- `--rpcapi` устанавливает что-то вроде прав доступа для приложений, подключенных к RPC серверу. Например, если вы не укажете `"miner"`, то, подключив к ноде кошелек и нажав на `Start miner`, вы получите ошибку. В примере указаны все возможные права, подробнее можете почитать [здесь](https://github.com/ethereum/go-ethereum/wiki/Management-APIs).
- `console` - как можно догадаться, эта опция запускает консоль разработчика. Она поддерживает самый обычный JS и ряд встроенных функций для работы с Ethereum, простой пример:

### [Parity](https://parity.io/)

Тем не менее в последнее время все чаще можно встретить другой клиент -  Parity, написанный на Rust. Рост его популярности во многом обеспечил [баг в Geth](https://blog.ethereum.org/2016/11/25/security-alert-11242016-consensus-bug-geth-v1-4-19-v1-5-2/), связанный с реализацией алгоритма консенсуса. Ну а на деле главным отличием является встроенный web интерфейс. Установка:

```bash
sudo <(curl https://get.parity.io -Lk)
```

По окончании загрузки запустите в консоли `parity` и по адресу [localhost:8180](localhost:8180) можете найти сам кошелек.

![parity](https://habrastorage.org/files/9b9/b1a/6f7/9b9b1a6f773e467a8edea7af404ba247.png)

Еще один плюс: Parity быстрее своих конкурентов. По крайней мере так утверждают авторы, но по моим ощущениям это действительно так.

### [TestRPC](https://github.com/ethereumjs/testrpc)

Этот инструмент, в отличие от предыдущих, будет полезен только разработчикам. Он позволяет одной командой `testrpc` поднять приватный блокчейн с включенным RPC протоколом, десятком заранее созданных аккаунтов с этерами на счету, работающим майнером, ... - весь список  [здесь](https://github.com/ethereumjs/testrpc#usage). По сути, `testrpc` - это тот же `geth --dev --rpc ...`, только на этот раз не надо тратить время на создание аккаунтов, включение / выключение майнера и прочие рутинные действия.

Установка - `npm install -g ethereumjs-testrpc`.

![testrpc](https://habrastorage.org/files/202/183/be8/202183be8fe3449fbf202f4b59bd2d73.png)

### [Mist](https://github.com/ethereum/mist)

Самый популярный кошелек для Ethereum, хотя на самом деле он умеет намного больше.

### [Remix](https://ethereum.github.io/browser-solidity/)

Самая популярная IDE для разработки контрактов. Работает в браузере по адресу [ethereum.github.io/browser-solidity/](ethereum.github.io/browser-solidity/), поддерживает огромное число функций:

- Подключение к указанному RPC провайдеру
- Компиляция кода в байткод / опкоды
- Публикация в Github gist
- Пошаговый дебагер
- Подсчет стоимости исполнения функций в газе
- И [многое другое](https://github.com/ethereum/remix)

При этом нет автокомплита, что очень печально.

![remix](https://habrastorage.org/files/cb0/5a0/e2b/cb05a0e2b23d42fdb62ddba02baaa44d.png)

### [Cosmo](https://github.com/cosmo-project/meteor-dapp-cosmo)

Еще одна IDE для разработки умных контрактов, написана на Meteor, работает из коробки. Для начала откройте новый терминал и поднимите ноду с включенным RPC интерфесом `geth --rpc --rpcapi="db,eth,net,web3,personal" --rpcport "8545" --rpcaddr "127.0.0.1" --rpccorsdomain "localhost" console`. После этого можете запускать саму IDE:

```bash
$ git clone http://github.com/SilentCicero/meteor-dapp-cosmo.git
$ cd meteor-dapp-cosmo/app
$ meteor
```

Далее открываете [localhost:3000](localhost:3000) и можете начинать работать:

![cosmo_screenshot](https://habrastorage.org/files/247/343/d06/247343d0657844469f2bbc8932e4fa58.jpg)

### [Etheratom](https://gitlab.com/0mkara/etheratom)

Еще один инструмент для ускорения разработки на Solidity. Это плагин для редактора Atom, устанавливается с помощью `apm install atom-ethereum-interface`. Штука удобная, сам пользуюсь. Позволяет работать c JS виртуалкой или подключиться к ноде через RPC. Компилирует контракт на `CTRL + ALT + C`, деплоит в сеть на `CTRL + ALT + S`. Ну и предоставляет неплохой интерфейс для работы с самим контрактом.

![atom_ethereum](https://habrastorage.org/files/c8d/00c/7f4/c8d00c7f419747e38e4d9579e4fe3cda.png)

Если вам не нужен такой навороченный функционал внутри редактора, то для Atom есть отдельный плагин с подсветкой синтаксиса Solidity - [language-ethereum](https://atom.io/packages/language-ethereum). Последний по сути является [плагином под Sublime text](https://packagecontrol.io/packages/Ethereum), только конвертированный для работы в Atom.

## Solidity

Возможно вы слышали про то, что можно писать контракты не только на Solidity, но и на других языках, например [Serpent](https://github.com/ethereum/wiki/wiki/Serpent). Но последний комит в develop ветке [ethereum/serpent](https://github.com/ethereum/serpent/tree/develop) был примерно полгода назад, так что по видимому язык, увы, deprecated.

Поэтому писать будем только на Solidity. Пока что язык находится на относительно раннем этапе развития, так что никаких сложных конструкций или уникальных абстракций в нем нет. Для примера рассмотрим самый простой контракт, который содержит в себе больше половины всех возможных тонкостей:

Весьма подробная [документация](https://solidity.readthedocs.io/en/develop/) языка, [местами](https://github.com/ethereum/wiki/wiki/%D0%A0%D1%83%D0%BA%D0%BE%D0%B2%D0%BE%D0%B4%D1%81%D1%82%D0%B2%D0%BE-%D0%BF%D0%BE-Solidity) даже переведена на русский язык.

## Создаем контракт-визитку

Самое время создать наш контракт. В конечном итоге это будет приложение-визитка, на которую мы поместим форму обратной связи и само "резюме":

- Имя, возраст, почта, страна и город
- Список проектов
- Образование : вузы, курсы и тд
- Навыки
- Любимые цитаты

### Шаблон

Первым делом создадим шаблон контракта и *функцию-конструктор*. Она должна называться также как и сам контракт и вызывается лишь однажды - при загрузке контракта в блокчейн. Мы будем использовать ее для инициализации одной единственной переменной - `address owner`. Как вы уже наверное догадались, в нее будет записан адрес того, кто залил контракт в сеть. А использоваться она будет для реализации функций администрирования, но об этом позже.

```javascript

```

### Базовая информация

### Модульность

Следующим шагом создадим несколько *структур* для описания проектов, образования, навыков и любимых цитат. Здесь все просто, структуры описываются точно так же как в Си. Но вместо того, чтобы описывать их в текущем контракте, вынесем их в отдельный контракт (в новом файле!), а `EthereumCV` от него унаследуем. Тем самым мы сможем избежать огромных простыней кода и структурировать наш проект.

Для этого в той же директории создадим новый файл `structures.sol` и контракт `Structures`. А уже внутри него опишем каждую из структур:

```javascript

```

Теперь осталось только импортировать полученный файл и унаследовать наш главный контракт от `Structures`. Для этого достаточно добавить всего пару строк:

```javascript

```

Самые сообразительные уже догадались, что нотация `Project[] projects` означает создание динамического массива с элеметнами типа `Project`. А вот с *модификатором* `public` уже сложнее. По сути, он заменяет нам написание функции вроде `get_project(int position)` - компилятор сделает всю работу за нас.

**BTW** На всякий случай отмечу, что кроме локального файла, **Remix** умеет импортировать `.sol` файлы по ссылке на Github и даже [с помощью протокола Swarm](https://www.reddit.com/r/ethereum/comments/5vpm53/remix_can_now_import_files_via_swarm/) (это что-то вроде распределенного хранилища для Ethereum, подробнее [здесь](http://ethereum.stackexchange.com/questions/375/what-is-swarm-and-what-is-it-used-for))

### Администрирование

Теперь стоит задуматься о наполнение нашего резюме всяческим контентом. Самая наивная реализация подразумевает четыре функции для каждого типа данных, что-то вроде:

```javascript
function newQuote(string author, string quote) {
  quotes.push(Quote(author, quote));
}

// Same functions for skills, projects, educations
// ...
```

Но в этом случае любой желающий сможет вызвать данную функцию и добавить в ваше резюме Бог знает что. Но этого можно избежать, прибегнув к ранее упомянутой переменной owner. Достаточно внутри каждой из функций сравнивать текущий адрес с owner, и завершать работу если они не равны.

```javascript
function newQuote(string author, string quote) {
  if (msg.sender != owner) { return; }
  quotes.push(Quote(author, quote));
}
```

Замечу, что привычный механизм авторизации через пароль здесь не имеет смысла: запомните как догму, **что все данные, попавшие в блокчейн становятся доступны всем без исключения**. Никаких встроенных механизмов шифрования или обфускации не существует. Поэтому достаточно самых базовых навыков реверс-инженеринга, чтобы достать ваш пароль и обойти защиту. Чуть лучше использовать хэши паролей (не забудьте посолить!), но все равно будьте готовы, что "достать" их из блокчейна - дело нескольких минут, после чего можно запускать радужные таблицы и проверять их на прочность.

Следующим шагом стоит задуматься о редактировании своего резюме. Не будем плодить лишних функций

### Отдаем данные 

### Форма обратной связи

### Деплой

## Добавляем UI

### [Web3.js](https://github.com/ethereum/web3.js)

```bash
sudo npm install web3 -g
```

### Metamask

### JS bindings

## Ссылки

- [MetaMask](https://medium.com/metamask/metamask-ff7d3571f331)
- [MetaMask 3 Migration Guide](https://medium.com/metamask/metamask-3-migration-guide-914b79533cdd)
- [Learning Solidity Part 1: Contract Dev with MetaMask](https://karl.tech/learning-solidity-part-1-deploy-a-contract/)
- [Learning Solidity Part 2: Commit-Reveal Voting](https://karl.tech/learning-solidity-part-2-voting/)
- [How to use MetaMask](https://www.cryptocompare.com/wallets/guides/how-to-use-metamask/)
- [Building an “Oracle” for an Ethereum contract](https://medium.com/@mustwin/building-an-oracle-for-an-ethereum-contract-6096d3e39551)
- [Full Stack Hello World Voting Ethereum Dapp Tutorial — Part 1](https://medium.com/@mvmurthy/full-stack-hello-world-voting-ethereum-dapp-tutorial-part-1-40d2d0d807c2)
- [Full Stack Hello World Voting Ethereum Dapp Tutorial — Part 2](https://medium.com/@mvmurthy/full-stack-hello-world-voting-ethereum-dapp-tutorial-part-2-30b3d335aa1f)