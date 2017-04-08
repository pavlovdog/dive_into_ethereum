# Dive into Ethereum

Хайп вокруг технологии **"blockchain"** растет с экспоненциалной скоростью.

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

Тем не менее в последнее время все чаще можно встретить другой клиент -  Parity, написанный на Rust. Главным его отличием от Geth является встроенный web интерфейс. Как по мне - самый удобный среди всех ныне существующих. Установка:

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

Поэтому писать будем только на Solidity. Пока что язык находится на относительно раннем этапе развития, так что никаких сложных конструкций или уникальных абстракций в нем нет. Так что рассказывать про него я не вижу смысла - любой человек с опытом в программировании сможет свободно писать на нем после 20 минут чтения документации. На ваш выбор существует сразу несколько очень хороших примеров с максимально подробными описаниями: 

- [Voting contract](http://solidity.readthedocs.io/en/develop/solidity-by-example.html#voting)
- [Blind Auction](http://solidity.readthedocs.io/en/develop/solidity-by-example.html#blind-auction)
- [Safe Remote Purchase](http://solidity.readthedocs.io/en/develop/solidity-by-example.html#safe-remote-purchase)
- Или, уже ставший аналогом "Hello, World" в мире контрактов, - [Greeter contract](https://www.ethereum.org/greeter)

Отдельно стоит отметить (отличную!) [документацию](https://solidity.readthedocs.io/en/develop/) языка, [местами](https://github.com/ethereum/wiki/wiki/%D0%A0%D1%83%D0%BA%D0%BE%D0%B2%D0%BE%D0%B4%D1%81%D1%82%D0%B2%D0%BE-%D0%BF%D0%BE-Solidity) даже переведена на русский язык.

## Создаем контракт-визитку

Самое время создать наш контракт. В конечном итоге это будет приложение-визитка, на которую мы поместим само "резюме":

- Имя, возраст, почта, страна и город
- Список проектов
- Образование : вузы, курсы и тд
- Навыки
- Любимые цитаты

Работатать с приложением можно будет как из обычных специальных клиентов вроде Parity, так и из обычного браузера.

### Шаблон

Первым делом создадим шаблон контракта и *функцию-конструктор*. Она должна называться также как и сам контракт и вызывается лишь однажды - при загрузке контракта в блокчейн. Мы будем использовать ее для инициализации одной единственной переменной - `address owner`. Как вы уже наверное догадались, в нее будет записан адрес того, кто залил контракт в сеть. А использоваться она будет для реализации функций администрирования, но об этом позже.

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

Следующим шагом добавим возможность указывать бакзовую информацию об авторе - имя, почту, адрес и так далее. Для этого будем использовать самый обычный mapping, который нужно объявить в начало контракта:

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

Здесь все просто, стоит только отметить модификатор constant - его можно (и нужно!) использовать для тех функций, которые не изменяют state приложения.

### Администрирование

Теперь стоит задуматься о наполнении своего резюме базовым контентом. В самом простом случае мы могли бы обойтись функцией вроде

```javascript
function setBasicData (string key, string value) {
	basic_data[key] = value;
}
```

Но в этом случае любой при желании смог бы изменить, например, наше имя. К счастью, есть способ всего в одну строку пресечь любые такие попытки:

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

function setBasicData (string key, string value) onlyOwner() {
	basic_data[key] = value;
}
```

### Модульность

Следующим шагом создадим несколько *структур* для описания проектов, образования, навыков и любимых цитат. Здесь все просто, структуры описываются точно так же как в Си. Но вместо того, чтобы описывать их в текущем контракте, вынесем их в отдельный контракт (в новом файле!), а `EthereumCV` от него унаследуем. Тем самым мы сможем избежать огромных простыней кода и структурировать наш проект.

Для этого в той же директории создадим новый файл `structures.sol` и контракт `Structures`. А уже внутри него опишем каждую из структур:

```javascript
pragma solidity ^0.4.0;

contract Structures {
    struct Project {
        string name;
        string link;
        string description;
        int32 year_start;
        int32 year_finish;
    }

    struct Education {
        string name;
        string speciality;
        int32 year_start;
        int32 year_finish;
    }

    struct Quote {
        string author;
        string quote;
    }

    struct Skill {
        string name;
        int32 level;
    }
}
```

Теперь осталось только импортировать полученный файл и унаследовать наш главный контракт от `Structures`. Для этого достаточно добавить всего пару строк:

```javascript
pragma solidity ^0.4.0;

import "./structures.sol";

contract EthereumCV is Structures {
    address owner;
    mapping (string => string) basic_data;

    Project[] public projects;
    Education[] public educations;
    Skill[] public skills;
    Quote[] public quotes;

	// ....
}
```

Самые сообразительные уже догадались, что нотация `Project[] projects` означает создание динамического массива с элеметнами типа `Project`. А вот с *модификатором* `public` уже сложнее. По сути, он заменяет нам написание функции вроде `get_project(int position) { return projects[position]; }` - компилятор сам создаст такую функцию. Называться она будет так же как и переменная, в нашем случае - projects.

Вы можете спросить - а почему мы в самом начале не написали `mapping (string => string) public basic_data`, а вместо этого сами создавали такую функцию? Причина банальна - `public` пока что не умеет работать c переменными, для которых ключом является динамический тип данных (`string` это именно такой тип).

```bash
Unimplemented feature (/src/libsolidity/codegen/ExpressionCompiler.cpp:105): Accessors for mapping with dynamically-sized keys not yet implemented.
```

В этом случае нужно объявлять `basic_data` как например `mapping (bytes32 => string)`.

**BTW** На всякий случай отмечу, что кроме локального файла, **Remix** умеет импортировать `.sol` файлы по ссылке на Github и даже [с помощью протокола Swarm](https://www.reddit.com/r/ethereum/comments/5vpm53/remix_can_now_import_files_via_swarm/) (это что-то вроде распределенного хранилища для Ethereum, подробнее [здесь](http://ethereum.stackexchange.com/questions/375/what-is-swarm-and-what-is-it-used-for))

### Загружаем и удаляем данные 

Думаю многие из вас уже сами догадались, как стоит реализовать такую функцию. Покажу на примере списка цитат, в остальных случаях все аналогично:

```javascript
function editQuote (bool operation, string author, string quote) onlyOwner() {
	if (operation) {
		quotes.push(Quote(author, quote));
	} else {
		delete quotes[quotes.length - 1];
	}
}
```

С помощью параметра `operation` мы избавились от написания отдельной функции для удаления последней цитаты (костыльный аналог `.pop()` в Python). Хотя нужно отметить, что такой способ избавления от элемента на самом деле не совсем корректный. Сам элемент конечно же будет удален, но на месте индекса останется пустое место. В нашем случае это не смертельно (мы будем проверять пустоту отдельных элементов на стороне клиента), но вообще говоря про это не стоит забывать. Тем более что сдвинуть весь массив  и уменьшить счетчик длины [не так уж сложно](http://ethereum.stackexchange.com/questions/1527/how-to-delete-an-element-at-a-certain-index-in-an-array).

### Отдаем данные

### Деплой



## Добавляем UI

Ниже я расскажу про самый распостраненный способ добавить интрефейс к вашему контракту.

### [Web3.js](https://github.com/ethereum/web3.js)

```bash
sudo npm install web3 -g
```

### [Metamask](https://metamask.io/)



### JS bindings



### Результат

Теперь, когда вы со всем разобрались, можно браться за верстку и JS. Я использовал [Vue.js](https://vuejs.org), 

## Ссылки

- [MetaMask](https://medium.com/metamask/metamask-ff7d3571f331)
- [Learning Solidity Part 1: Contract Dev with MetaMask](https://karl.tech/learning-solidity-part-1-deploy-a-contract/)
- [Learning Solidity Part 2: Commit-Reveal Voting](https://karl.tech/learning-solidity-part-2-voting/)
- [How to use MetaMask](https://www.cryptocompare.com/wallets/guides/how-to-use-metamask/)
- [Building an “Oracle” for an Ethereum contract](https://medium.com/@mustwin/building-an-oracle-for-an-ethereum-contract-6096d3e39551)
- [Full Stack Hello World Voting Ethereum Dapp Tutorial — Part 1](https://medium.com/@mvmurthy/full-stack-hello-world-voting-ethereum-dapp-tutorial-part-1-40d2d0d807c2)
- [Full Stack Hello World Voting Ethereum Dapp Tutorial — Part 2](https://medium.com/@mvmurthy/full-stack-hello-world-voting-ethereum-dapp-tutorial-part-2-30b3d335aa1f)