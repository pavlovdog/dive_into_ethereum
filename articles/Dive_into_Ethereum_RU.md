Сегодня платформа Ethereum стала одним из самых узнаваемых брендов блокчейн сферы, вплотную приблизившись по популярности (и капитализации) к Bitcoin. Но из-за отсутствия "полноценного" рускоязычного гайда, отечественные разработчики все еще не очень понимают, что это за зверь и как с ним работать. Поэтому в данной статье я попытался максимально подробно охватить все аспекты разработки умных контрактов под Ethereum.

Я расскажу про инструменты разработки, сам ЯП, процесс добавления UI и еще много интересного. В конечном итоге мы получим обычный сайт-визитку, но "под капотом" он будет работать на умных контрактах Ethereum. Кого заинтересовало - прошу под кат.

![preview](https://habrastorage.org/files/b31/607/cf2/b31607cf2d2143a3b5452acc1a85f011.jpg)

## Содержание

- [Введение в Ethereum](#vvedenie-v-ethereum)
- [Инструменты](#instrumenty)
  - [Geth](#gethhttpsethereumgithubiogo-ethereum)
  - [Parity](#parityhttpsparityio)
  - [TestRPC](#testrpchttpsgithubcomethereumjstestrpc)
  - [Mist](#misthttpsgithubcomethereummist)
  - [Remix](#remixhttpsethereumgithubiobrowser-solidity)
  - [Cosmo](#cosmohttpsgithubcomcosmo-projectmeteor-dapp-cosmo)
  - [Etheratom](#etheratomhttpsgitlabcom0mkaraetheratom)
- [Solidity](#solidity)
- [Создаем контракт-визитку](#sozdaem-kontrakt-vizitku)
  - [Первый шаг](#pervyy-shag)
  - [Базовая информация](#bazovaya-informaciya)
  - [Администрирование](#administrirovanie)
  - [Модульность](#modulnost)
  - [Загружаем и удаляем данные](#zagruzhaem-i-udalyaem-dannye)
  - [Отдаем данные](#otdaem-dannye)
  - [Деплой](#deploy)
- [Добавляем UI](#dobavlyaem-ui)
  - [Web3.js](#web3jshttpsgithubcomethereumweb3js)
  - [Metamask](#metamaskhttpsmetamaskio)
  - [Deploy with Metamask](#deploy-with-metamask)
  - [Пример](#primer)
  - [Итог](#itog)
- [Вместо заключения](#vmesto-zaklyucheniya)
- [Ссылки](#ssylki)

## Введение в Ethereum
Эта статья не расчитана на тех, кто совсем не знаком с Ethereum (или технологией блокчейн вообще), поэтому объяснений базовых вещей вроде *блоков*, *транзакций* или *контрактов* здесь не будет. Я подразумеваю, что вы хотя бы чуть-чуть в курсе происходящего. В противном случае полистайте статьи из списка ниже, а потом возвращайтесь :)

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

**P.S.** Я работаю под Ubuntu 16.04, так что весь процесс установки, разработки и деплоя будет описан под эту ОС. Тем не менее все используемые инструменты кроссплатформенны (скорее всего, не проверял), так что при желании можете поэкспериментировать на других ОС.

## Инструменты

### [Geth](https://ethereum.github.io/go-ethereum/)

Работа с Ethereum возможна через огромное число клиентов, часть из которых terminal-based, часть GUI и есть несколько гибридных решений. Своего рода стандартом является [Geth](), который разрабатывается командой Ethereum. Про него я уже писал в [предыдущих статьях](https://habrahabr.ru/post/312008/), но на всякий случай повторюсь.

Клиент написан на Go, устанавливается [стандартным способом](https://www.ethereum.org/cli):

```bash
sudo apt-get install software-properties-common
sudo add-apt-repository -y ppa:ethereum/ethereum
sudo apt-get update
sudo apt-get install ethereum
```

Сам Geth не имеет GUI, но работать с ним из терминала довольно приятно. [Здесь](https://github.com/ethereum/go-ethereum/wiki/Command-Line-Options) описан весь набор аргументов командной строки, я же опишу несколько самых популярных.

Вот команда, которую я чаще всего использую в работе: `$ geth --dev --rpc --rpcaddr "0.0.0.0" --rpcapi "admin,debug,miner,shh,txpool,personal,eth,net,web3" console`

- `--dev` запускает geth в режиме приватного блокчейна, то есть не синхронизирет основную / тестовую ветку. Вместо этого вы получаете стерильную цепочку без единого блока. Это самый удобный вариант в плане разработки, так как, например, майнинг блока занимает несколько секунд и нет никакой нагрузки на сеть или диск.

- `--rpc` включает RPC-HTTP сервер. По сути это API к вашей ноде - через него сторонние приложения, вроде кошельков или IDE, смогут работать с блокчейном: загружать контракты, отправлять транзакции и так далее. По дефолту запускается на [localhost:8545](http://localhost:8545), можете изменить эти параметры с помощью `--rpcaddr` и `--rpcport` соответственно.
- `--rpcapi` устанавливает что-то вроде прав доступа для приложений, подключенных к RPC серверу. Например, если вы не укажете `"miner"`, то, подключив к ноде кошелек и запустив майнер, вы получите ошибку. В примере я указал все возможные права, подробнее можете почитать [здесь](https://github.com/ethereum/go-ethereum/wiki/Management-APIs).
- `console` - как можно догадаться, эта опция запускает консоль разработчика. Она поддерживает самый обычный JS и ряд встроенных функций для работы с Ethereum, вот простой [пример](https://habrahabr.ru/post/312008/) (пункт - Поднимаем ноду).

### [Parity](https://parity.io/)

Geth довольно хорош, но в последнее время все чаще можно встретить другой клиент -  Parity, написанный на Rust. Главным его отличием от Geth является встроенный web интерфейс, на мой взгляд, самый удобный среди всех ныне существующих. Установка:

```bash
sudo <(curl https://get.parity.io -Lk)
```

По окончании загрузки запустите в консоли `parity` и по адресу [localhost:8180](localhost:8180) можете найти сам кошелек.

![parity](https://habrastorage.org/files/9b9/b1a/6f7/9b9b1a6f773e467a8edea7af404ba247.png)

Еще один плюс: Parity быстрее своих конкурентов. По крайней мере так утверждают авторы, но по моим ощущениям это действительно так, особенно в плане синхронизации блокчейна.

Единственный нюанс - своей консоли в parity нет. Но можно без проблем использовать для этих целей Geth:

```bash
$ parity --geth # Run parity in Geth mode
$ geth attach console # Attach Geth to the PArity node (Do it in another window)
```

### [TestRPC](https://github.com/ethereumjs/testrpc)

Этот инструмент, в отличие от предыдущих, будет полезен только разработчикам. Он позволяет одной командой `testrpc` поднять приватный блокчейн с включенным RPC протоколом, десятком заранее созданных аккаунтов с этерами на счету, работающим майнером и так далее. Весь список  [здесь](https://github.com/ethereumjs/testrpc#usage). По сути, `testrpc` - это тот же `geth --dev --rpc ...`, только на этот раз не надо тратить время на создание аккаунтов, включение / выключение майнера и прочие рутинные действия.

Установка - `npm install -g ethereumjs-testrpc`.

![testrpc](https://habrastorage.org/files/202/183/be8/202183be8fe3449fbf202f4b59bd2d73.png)

### [Mist](https://github.com/ethereum/mist)

Самый популярный кошелек для Ethereum, хотя на самом деле он умеет намного больше. Вот [отличная статья](https://medium.com/@attores/step-by-step-guide-getting-started-with-ethereum-mist-wallet-772a3cc99af4), где step-by-step объясняется весь процесс работы с Mist. Скачать самую свежую версию можно со [страницы релизов](https://github.com/ethereum/mist/releases). Помимо работы с кошельком, есть возможность работы с контрактами.

![mist](https://habrastorage.org/files/8b0/6a9/389/8b06a93898c841848a35213439cf27ec.png)

### [Remix](https://ethereum.github.io/browser-solidity/)

Самая популярная IDE для разработки контрактов. Работает в браузере по адресу [ethereum.github.io/browser-solidity/](https://ethereum.github.io/browser-solidity/), поддерживает огромное число функций:

- Подключение к указанному RPC провайдеру
- Компиляция кода в байткод / опкоды
- Публикация в Github gist
- Пошаговый дебагер
- Подсчет стоимости исполнения функций в газе
- Сохранение вашего кода в localstorage
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

Последний на сегодня инструмент для ускорения разработки умных контрактов. Это плагин для редактора Atom, устанавливается с помощью `apm install atom-ethereum-interface`. Штука удобная, сам пользуюсь. Позволяет работать c JS EVM или подключиться к ноде через RPC. Компилирует контракт на `CTRL + ALT + C`, деплоит в сеть на `CTRL + ALT + S`. Ну и предоставляет неплохой интерфейс для работы с самим контрактом.

![atom_ethereum](https://habrastorage.org/files/c8d/00c/7f4/c8d00c7f419747e38e4d9579e4fe3cda.png)

Если вам не нужен такой навороченный функционал внутри редактора, то для Atom есть отдельный плагин с подсветкой синтаксиса Solidity - [language-ethereum](https://atom.io/packages/language-ethereum). Последний по сути является [плагином под Sublime text](https://packagecontrol.io/packages/Ethereum), только конвертированный для работы в Atom.

## Solidity

Возможно, вы слышали про то, что можно писать контракты не только на Solidity, но и на других языках, например [Serpent](https://github.com/ethereum/wiki/wiki/Serpent) (внешне напоминает Python). Но последний комит в develop ветке [ethereum/serpent](https://github.com/ethereum/serpent/tree/develop) был примерно полгода назад, так что, по-видимому, язык, увы, deprecated.

Поэтому писать будем только на Solidity. Пока что язык находится на относительно раннем этапе развития, так что никаких сложных конструкций или уникальных абстракций в нем нет. Поэтому отдельно рассказывать про него я не вижу смысла - любой человек с опытом в программировании сможет свободно писать на нем после 20 минут чтения [документации](https://solidity.readthedocs.io/en/develop/). На случай, если у вас такого опыта нет, - ниже я довольно подробно прокомментировал весь код контракта.

Для самостоятельного обучения есть несколько очень хороших примеров с максимально подробными описаниями:

- [Voting contract](http://solidity.readthedocs.io/en/develop/solidity-by-example.html#voting)
- [Blind Auction](http://solidity.readthedocs.io/en/develop/solidity-by-example.html#blind-auction)
- [Safe Remote Purchase](http://solidity.readthedocs.io/en/develop/solidity-by-example.html#safe-remote-purchase)
- Или, уже ставший аналогом "Hello, World" в мире контрактов, - [Greeter contract](https://www.ethereum.org/greeter)

Еще раз отмечу (отличную!) [документацию](https://solidity.readthedocs.io/en/develop/) языка, [местами](https://github.com/ethereum/wiki/wiki/%D0%A0%D1%83%D0%BA%D0%BE%D0%B2%D0%BE%D0%B4%D1%81%D1%82%D0%B2%D0%BE-%D0%BF%D0%BE-Solidity) даже переведена на русский язык.

## Создаем контракт-визитку

Самое время создать наш контракт. В конечном итоге это будет приложение-визитка, на которую мы поместим само "резюме":

- Имя, почта, контакты и так далее
- Список проектов
- Образование : вузы, курсы и тд
- Навыки
- Публикации

### Первый шаг

Первым делом создадим шаблон контракта и *функцию-конструктор*. Она должна называться также как и сам контракт и вызывается лишь однажды - при загрузке контракта в блокчейн. Мы будем использовать ее для инициализации одной единственной переменной - `address owner`. Как вы уже наверное догадались, в нее будет записан адрес того, кто залил контракт в сеть. А использоваться она будет для реализации функций администратора контракта, но об этом позже.

```javascript
pragma solidity ^0.4.0;

contract EthereumCV is Structures {
    address owner;

    // =====================
    // ==== CONSTRUCTOR ====
    // =====================
    function EthereumCV() {
        owner = msg.sender;
    }
}
```

### Базовая информация

Следующим шагом добавим возможность указывать базовую информацию об авторе - имя, почту, адрес и так далее. Для этого будем использовать самый обычный `mapping`, который нужно объявить в начало контракта:

```javascript
address owner;
mapping (string => string) basic_data;
```

Для того, чтобы иметь возможность "получать" от контракта эти данные, создадим следующую функцию:

```javascript
function getBasicData (string arg) constant returns (string) {
	return basic_data[arg];
}
```

Здесь все просто, стоит только отметить модификатор `constant` - его можно (и нужно) использовать для тех функций, которые не изменяют *state* приложения. Главный плюс таких функций (sic!), в том что их можно использовать как обычные функции.

### Администрирование

Теперь стоит задуматься о наполнении своего резюме контентом. В самом простом случае мы могли бы обойтись функцией вроде

```javascript
function setBasicData (string key, string value) {
	basic_data[key] = value;
}
```

Но в этом случае любой при желании смог бы изменить, например, наше имя, вызвав `setBasicData("name", "New Name")`. К счастью, есть способ всего в одну строку пресечь любые такие попытки:

```javascript
function setBasicData (string key, string value) {
	if (msg.sender != owner) { throw; }
	basic_data[key] = value;
}
```

Так как нам еще не раз придется использовать подобную конструкцию (при добавлении нового проекта, например), то стоит создать специальный *модификатор*:

```javascript
modifier onlyOwner() {
	if (msg.sender != owner) { throw; }
	_; // Will be replaced with function body
}

// Now you can use it with any function
function setBasicData (string key, string value) onlyOwner() {
	basic_data[key] = value;
}
```

При желании, можно использовать другие способы авторизации, например по паролю. Хэш будет храниться в контракте и сравниваться с введенным при каждом вызове функции. Но понятно, что этот способ не такой безопасный, благо радужные таблицы и атаки по словарю никто не отменял. С другой стороны, наш способ тоже не идеален, так как если вы потеряете доступ к адресу `owner`, то ничего редактировать вы уже не сможете.

### Модульность

Следующим шагом создадим несколько *структур* для описания проектов, образования, навыков и публикаций. Здесь все просто, структуры описываются точно так же как в Си. Но вместо того, чтобы описывать их в текущем контракте, вынесем их в отдельную блиблиотеку (в новом файле). Тем самым мы сможем избежать огромных простыней кода и структурировать наш проект.

Для этого в той же директории создадим новый файл `structures.sol` и библиотеку `Structures`. А уже внутри нее опишем каждую из структур:

```javascript
pragma solidity ^0.4.0;

library Structures {
    struct Project {
        string name;
        string link;
        string description;
    }

    struct Education {
        string name;
        string speciality;
        int32 year_start;
        int32 year_finish;
    }

    struct Publication {
        string name;
        string link;
        string language;
    }

    struct Skill {
        string name;
        int32 level;
    }
}
```

Теперь осталось только импортировать полученный файл

```javascript
pragma solidity ^0.4.0;

import "./structures.sol";

contract EthereumCV {
    mapping (string => string) basic_data;
    address owner;

    Structures.Project[] public projects;
    Structures.Education[] public educations;
    Structures.Skill[] public skills;
    Structures.Publication[] public publications;

  	// ...
}
```

Самые сообразительные уже догадались, что нотация `Structures.Project[] projects` означает создание динамического массива с элеметнами типа `Project`. А вот с *модификатором* `public` уже сложнее. По сути, он заменяет нам написание функции вроде `get_project(int position) { return projects[position]; }` - компилятор сам создаст такую функцию. Называться она будет так же как и переменная, в нашем случае - `projects`.

Вы можете спросить - почему мы в самом начале не написали `mapping (string => string) public basic_data`, а вместо этого сами создавали такую функцию? Причина банальна - `public` пока что не умеет работать c переменными, для которых ключом является динамический тип данных (`string` именно такой тип).

```bash
Unimplemented feature (/src/libsolidity/codegen/ExpressionCompiler.cpp:105): Accessors for mapping with dynamically-sized keys not yet implemented.
```

Для этого нужно объявлять `basic_data` как например `mapping (bytes32 => string)`.

**BTW** На всякий случай отмечу, что кроме локального файла, **Remix** умеет импортировать `.sol` файлы по ссылке на Github и даже [с помощью протокола Swarm](https://www.reddit.com/r/ethereum/comments/5vpm53/remix_can_now_import_files_via_swarm/) (это что-то вроде распределенного хранилища для Ethereum, подробнее [здесь](http://ethereum.stackexchange.com/questions/375/what-is-swarm-and-what-is-it-used-for))

### Загружаем и удаляем данные

Думаю многие из вас уже сами догадались, как стоит реализовать работу с новыми данными. Покажу на примере списка публикаций, в остальных случаях все аналогично:

```javascript
function editPublication (bool operation, string name, string link, string language) onlyOwner() {
    if (operation) {
        publications.push(Structures.Publication(name, link, language));
    } else {
        delete publications[publications.length - 1];
    }
}
```

С помощью параметра `operation` мы избавились от написания отдельной функции для удаления последней публикации (костыльно, но мы ведь только учимся). Хотя нужно отметить, что такой способ избавления от элемента в массиве на самом деле не совсем корректный. Сам элемент конечно будет удален, но на месте индекса останется пустое место. В нашем случае это не смертельно (мы будем проверять пустоту отдельных элементов на стороне клиента), но, вообще говоря, про это не стоит забывать. Тем более что сдвинуть весь массив  и уменьшить счетчик длины [не так уж сложно](http://ethereum.stackexchange.com/questions/1527/how-to-delete-an-element-at-a-certain-index-in-an-array).

### Отдаем данные

Как я уже сказал, модификатор `public` в строке `Project[] public projects` обеспечил нас функцией которая по индексу `i` вернет проект `projects[i]`. Но мы не знаем, сколько у нас всего проектов, и здесь есть два пути. Первый  - итерироваться по `i` до того момента, пока мы не получим ошибку о несуществующем элементе. Второй - написать отдельную функцию, которая вернет нам размер `projects`. Я пойду вторым путем, чуть позже скажу почему:

```javascript
function getSize(string arg) constant returns (uint) {
    if (sha3(arg) == sha3("projects")) { return projects.length; }
    if (sha3(arg) == sha3("educations")) { return educations.length; }
    if (sha3(arg) == sha3("publications")) { return quotes.length; }
    if (sha3(arg) == sha3("skills")) { return skills.length; }
    throw;
}
```
Заметьте, что мы не можем сравнить две строки привычным способом `'aaa' == 'bbb'`. Причина все та же, `string` - это динамический тип данных, работа с ними довольно болезненна. Так что остается либо сравнивать хэши, либо использовать функцию для посимвольного сравнения.  В этом случае можете использовать популярную библиотеку [stringUtils.sol](https://github.com/ethereum/dapp-bin/blob/master/library/stringUtils.sol), в ней есть такая функция.

### Деплой

В разных средах разработки процесс компиляции и деплоя разумеется отличается, поэтому я ограничусь Remix, как самым популярным.

Сначала, само собой, заливаем весь код (финальную версию можете найти в [репозитории проекта](https://github.com/pavlovdog/dive_into_ethereum)). Далее в выпадающем списке **Select execution environment** выберите `Javascript VM` - пока что протестируем контракт на JS эмуляторе блокчейна, чуть позже научимся работать и с настоящим. Если с контрактом все в порядке, то вам будет доступна кнопка **Create** - нажимаем и видим:

![remix_create](https://habrastorage.org/files/f07/133/8f8/f071338f8a064ea596389be591510206.png)

Теперь, когда контракт залит в блокчейн (его эмуляцию, но не суть), можем попробовать вызвать какую-нибудь функцию и посмотреть, что из этого выйдет. Например можно сохранить в контракте email - для этого найдите функцию `setBasicData`, заполните поле и нажмите кнопку с именем функции:

![remix_set_basic_data](https://habrastorage.org/files/a10/091/6ad/a100916ad88d4ccdb18fc214b7008d7b.jpg)

Функция ничего не возвращает, поэтому `result: 0x`. Теперь можно запросить у контракта email: ищем функцию `getBasicData` и пробуем:

![remix_get_basic_data](https://habrastorage.org/files/c8f/f26/f6a/c8ff26f6ac7740c2934cdf93b8a3c871.jpg)

С остальными функциями предлагаю вам поэксперементировать самим.

## Добавляем UI

Ниже я расскажу про самый распостраненный способ добавить UI к вашему контракту. Он позволяет с помощью JS и HTML создавать интерфейсы любой сложности, достаточно иметь доступ к рабочей ноде Ethereum (или ее аналогам).

### [Web3.js](https://github.com/ethereum/web3.js)

> This is the Ethereum compatible [JavaScript API](https://github.com/ethereum/wiki/wiki/JavaScript-API) which implements the [Generic JSON RPC](https://github.com/ethereum/wiki/wiki/JSON-RPC) spec. It's available on npm as a node module, for bower and component as an embeddable js and as a meteor.js package.
>

Это JS библиотека, позовляющая использовать API Ethereum с помощью обычного JS. По сути с ее помощью вы просто подключаетесь ноде и у вас появляется что-то вроде консоли geth в браузере. Устанавливается через `npm` или `bower`:

```bash
$ sudo npm install web3
$ bower install web3
```

Вот пример работы с web3 через node.js (предварительно запустите `testrpc `или любую другую ноду с RPC интерфейсом):

```javascript
$ node
> var Web3 = require('web3');
> var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
> web3.eth.accounts
[ '0x5f7aaf2199f95e1b991cb7961c49be5df1050d86',
  '0x1c0131b72fa0f67ac9c46c5f4bd8fa483d7553c3',
  '0x10de59faaea051b7ea889011a2d8a560a75805a7',
  '0x56e71613ff0fb6a9486555325dc6bec8e6a88c78',
  '0x40155a39d232a0bdb98ee9f721340197af3170c5',
  '0x4b9f184b2527a3605ec8d62dca22edb4b240bbda',
  '0x117a6be09f6e5fbbd373f7f460c8a74a0800c92c',
  '0x111f9a2920cbf81e4236225fcbe17c8b329bacd7',
  '0x01b4bfbca90cbfad6d6d2a80ee9540645c7bd55a',
  '0x71be5d7d2a53597ef73d90fd558df23c37f3aac1' ]
>
```

Тоже самое, только из JS консоли браузера (не забудьте про `<script src="path_to/web3.js"></script>`)

![browser_js_web3](https://habrastorage.org/files/8e0/c98/d16/8e0c98d16a55496a91e9af862f40f647.jpg)

То есть мы уже на этом моменте можем запустить ноду, синхронизировать ее с текущей цепочкой и останется только сверстать наше приложение. Но тут есть два тонких момента: во-первых, вам нужно синхронизировать блокчейн Ethereum, а вы этого скорее всего до сих пор не сделали.

Второй нюанс - RPC не имеет никакого встроенного механизма авторизации, поэтому любой желающий может узнать адрес вашей ноды из исходников JS и пользоваться ей в свое удовольствие. Тут конечно можно писать какую-нибудь обертку на Nginx с простейшей HTTP basic auth, но это как-нибудь в другой раз.

### [Metamask](https://metamask.io/)

Поэтому сейчас мы воспользуемся плагином Metamask (увы, только для Chrome). По сути это и есть та прослойка между нодой и браузером, которая позволит вам использовать web3 в браузере, но без своей ноды. Metamask работает очень просто - в каждую страницу он встраивает web3.js, который автоматически подключается к RPC серверам Metamask. После этого вы можете использовать Ethereum на полную катушку.

После установки плагина, в левом верхнем углу выберите `Testnet` и получите несколько эфиров на [кране Metamask](https://faucet.metamask.io/). На этом моменте вы должны получить что-то вроде такого (с чистой историей разумеется):

![metamask_ready](https://habrastorage.org/files/f6c/4a4/68e/f6c4a468e3fb4e85bc85616f6dffce07.jpg)

### Deploy with Metamask

С Metamask задеплоить контракт в сеть так же просто, как и в случаем с JS EVM. Для этого снова открываем Remix и в списке **Select execution environment** выбираем пункт `Injected Web3` (скорее всего он выбран автоматически). После этого нажимаем Create и видим всплывающее окно:

![metamask_popup](https://habrastorage.org/files/22f/d03/93e/22fd0393ebc14dd788c0cd2733fb911f.jpg)

Чуть позже надпись `Waiting for transaction to be mined..`. сменится на информацию об опубликованном контракте - это значит что он попал в блокчейн. Адрес контракта можете узнать, открыв Metamask и нажав на запись вида:

![metamask_info](https://habrastorage.org/files/f17/887/218/f178872182be4fb083518678faa4cfe2.jpg)

Однако теперь, если вы захотите, например, вызвать функцию `editProject(...)`, то вам так же придется подтвержать транзакцию и ждать, пока она будет замайнена в блок.

### Пример

Теперь дело за малым - надо научиться получать данные от контракта через Web3. Для этого, во-первых, надо научиться определять наличие web3 на странице:

```javascript
window.addEventListener('load', function() {
  // Checking if Web3 has been injected by the browser (Mist/MetaMask)
  if (typeof web3 !== 'undefined') {
    // Use Mist/MetaMask's provider
    console.log("Web3 detected!");
    window.web3 = new Web3(web3.currentProvider);
    // Now you can start your app & access web3 freely:
    startApp()
  } else {
    alert('Please use Chrome, install Metamask and then try again!')
  }
})
```

Внутри `startApp()` я определелил всю логику работы с контрактом, тем самым избегая ложных срабатываний и ошибок.

```javascript
function startApp() {
  var address = {
    "3" : "0xf11398265f766b8941549c865d948ae0ac734561" // Ropsten
  }

  var current_network = web3.version.network;
  // abi initialized ealier, in abi.js
  var contract = web3.eth.contract(abi).at(address[current_network]);

  console.log("Contract initialized successfully")

  contract.getBasicData("name", function(error, data) {
    console.log(data);
  });

  contract.getBasicData("email", function(error, data) {
    console.log(data);
  });

  contract.getSize("skills", function(error, data) {
    var skills_size = data["c"][0];
    for (var i = 0; i < skills_size; ++i) {
      contract.skills(i, function(error, data) {
        // Don't forget to check blank elements!
        if (data[0]) { console.log(data[0], data[1]["c"][0]); }
      })
    }
  })
}
```

![js_logs](https://habrastorage.org/files/ed3/5cd/eb4/ed35cdeb43b64f5393d4ea9e29093c86.jpg)

### Итог

Теперь, когда вы со всем разобрались, можно браться за верстку и JS. Я использовал [Vue.js](https://vuejs.org) и [Spectre.css](https://picturepan2.github.io/spectre/), для визуализации навыков добавил [Google Charts](https://developers.google.com/chart/).  Результат можете увидеть на [pavlovdog.github.io](https://pavlovdog.github.io/):

![cv](https://habrastorage.org/files/7fe/505/d75/7fe505d7535e4866a37bc6a70562dcdc.jpg)

## Вместо заключения

Только что вы увидели, как можно довольно быстро создать приложение, которое самым непосредственным образом использует технологию blockchain. Хотя в погоне за простотой (все таки это обучающая статья) я допустили некоторые упрощения, которые по-хорошему допускать нельзя.

Например, мы используем чей-то шлюз (я про Metamask), вместо того, чтобы работать со своей нодой. Это удобно, но технология блокчейн в первую очередь - децентрализация и отсутствие посредников. У нас же всего этого нет - мы **доверяем** парням из Metamask.

Другая, не такая критичная проблема, - мы забыли про стоимость деплоя контрактов и транзакций к ним. На практике, стоит десять раз подумать, прежде чем использовать `string` вместо `bytes`, потому как такие вещи прежде всего влияют на затраты при работе с контрактом. Опять же, в примере я использовал `Testnet`, так что никаких денег мы не потратили, но при работе с `Main net` не стоит быть такими расточительными.

В любом случае, я надеюсь что статья оказалась полезной, если есть вопросы - задавайте в комментариях или пишите мне на почту.

## Ссылки

- [MetaMask](https://medium.com/metamask/metamask-ff7d3571f331)
- [Learning Solidity Part 1: Contract Dev with MetaMask](https://karl.tech/learning-solidity-part-1-deploy-a-contract/)
- [Learning Solidity Part 2: Commit-Reveal Voting](https://karl.tech/learning-solidity-part-2-voting/)
- [How to use MetaMask](https://www.cryptocompare.com/wallets/guides/how-to-use-metamask/)
- [Building an “Oracle” for an Ethereum contract](https://medium.com/@mustwin/building-an-oracle-for-an-ethereum-contract-6096d3e39551)
- [Full Stack Hello World Voting Ethereum Dapp Tutorial — Part 1](https://medium.com/@mvmurthy/full-stack-hello-world-voting-ethereum-dapp-tutorial-part-1-40d2d0d807c2)
- [Full Stack Hello World Voting Ethereum Dapp Tutorial — Part 2](https://medium.com/@mvmurthy/full-stack-hello-world-voting-ethereum-dapp-tutorial-part-2-30b3d335aa1f)
