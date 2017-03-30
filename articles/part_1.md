# Разрабатываем full-stack приложение на Ethereum (Часть 1) - разработка контракта

Хайп вокруг технологии **"blockchain"** растет с экспоненциалной скоростью. В этом можно убедиться, как пролистав ленты популярных новостных агенств или открыв Google Trends, так и посмотрев на курсы  криптовалют и капитализации отдельных компаний. Одновременно с этим для обычного пользователя вся эта шумиха продолжает оставаться чем-то загадочным и непонятным (что совершенно нормально!). Другое дело, что большинство разработчиков точно также упорно не понимают, о чем вся эта _цепочка блоков_ и есть ли от нее толк на практике?

В этом небольшом цикле статей я постараюсь продемонстрировать работу с технологией блокчейн на масимально приближенном к реальности примере: с помощью платформы Ethereum мы создадим приложение наподобие сайта-визитной карточки, в котором можно будет описать свои проекты, навыки, контакты и прочее. Для пущей сложности добавим к этому форму обратной связи, чтобы соискатели могли отправить вам сообщение. Тем самым мы получим полноценное динамическое приложение, расположенное внутри блокчейна и работающее в обычном браузере!

## Содержание

## Введение в Ethereum
Эта статья не расчитана на тех, кто совсем не знаком с Ethereum, поэтому объяснений базовых вещей вроде *блоков*, *транзакций* или *контрактов* здесь не будет. Вместо это я подразумеваю, что вы хотя бы чуть-чуть в теме. В противном случае прочитайте статьи из списка ниже, а потом возвращайтесь :)

- [RU - Пишем умный контракт на Solidity. Часть 1 — установка и «Hello world»](https://habrahabr.ru/post/312008/)
- [RU - Malware + Blockchain = ❤️](https://habrahabr.ru/post/313710/)
- [RU - Как мы делали первую сделку-аккредитив на блокчейн в Альфа-Банке](https://habrahabr.ru/company/alfa/blog/323070/)
- [EN - Ethereum for web developers](https://medium.com/@mvmurthy/ethereum-for-web-developers-890be23d1d0c)
- [EN - Building a smart contract using the command line](https://www.ethereum.org/greeter)
- [EN - Create your own crypto-currency](https://www.ethereum.org/token)
- [EN - Dapps for Beginners](https://dappsforbeginners.wordpress.com/)
- [EN - A 101 Noob Intro to Programming Smart Contracts on Ethereum](http://consensys.github.io/developers/articles/101-noob-intro/)

Больше ссылок на интересные статьи вы найдете в конце.

**P.S.** Я работаю под Ubuntu 16.04, так что весь процесс установки, разработки и деплоя будет описан под эту ОС. Тем не менее все используемые инструменты кроссплатформенны (скорее всего), так что при желании можете поэкспериментировать на других ОС.

## Настройка окружения

### [Geth](https://ethereum.github.io/go-ethereum/)

Работа с Ethereum возможна через огромное число клиентов, часть из которых terminal-based, часть GUI и есть несколько гибридных решений. Своего рода стандартом является [Geth](), который разрабатывается самой командой Ethereum. Про него я уже писал в [предыдущих статьях](https://habrahabr.ru/post/312008/), но на всякий случай повторюсь.

Клиент написан на Go, устанавливается [стандартным способом](https://www.ethereum.org/cli):

```bash
sudo apt-get install software-properties-common
sudo add-apt-repository -y ppa:ethereum/ethereum
sudo apt-get update
sudo apt-get install ethereum
```

Сам Geth не имеет GUI, но работать с ним из терминала довольно приятно. [Здесь](https://github.com/ethereum/go-ethereum/wiki/Command-Line-Options) описан весь набор аргументов командной строки, я же опишу несколько самых популярных.

### [Parity](https://parity.io/)

Тем не менее в последнее время все чаще можно встретить другой клиент -  Parity, написанный на Rust. Рост его популярности во многом обеспечил [баг в Geth](https://blog.ethereum.org/2016/11/25/security-alert-11242016-consensus-bug-geth-v1-4-19-v1-5-2/), связанный с реализацией алгоритма консенсуса. Ну а на деле главным отличием является встроенный web интерфейс. Установка:

``` bash
sudo <(curl https://get.parity.io -Lk)
```

По окончании загрузки запустите в консоли parity и по адресу [localhost:8180](localhost:8180) можете найти сам кошелек.

### [Mist](https://github.com/ethereum/mist)

### [Remix](https://ethereum.github.io/browser-solidity/)

Самая популярная IDE для разработки контрактов. Работает внутри браузера, поддерживает, наверное, все возможные функции:

- Подключение к указанному RPC провайдеру
- Компиляция 
- Публикация в Github gist
- Пошаговый дебагер
- Компиляция в байткод / опкоды
- Подсчет стоимости исполнения функция в газе
- И многое другое

При этом нет автокомплита, что очень печально.

### [Cosmo](https://github.com/cosmo-project/meteor-dapp-cosmo)

Это IDE для разработки умных контрактов. Штука удобная, написана на Meteor, работает из коробки. Для начала откройте новый терминал и запустите ноду с включенным RPC интерфесом `geth --rpc --rpcapi="db,eth,net,web3,personal" --rpcport "8545" --rpcaddr "127.0.0.1" --rpccorsdomain "localhost" console`.

```bash
$ git clone http://github.com/SilentCicero/meteor-dapp-cosmo.git
$ cd meteor-dapp-cosmo/app
$ meteor
```

Далее открываете [localhost:3000](localhost:3000) и видите следующую картину:

![cosmo_screenshot](https://habrastorage.org/files/247/343/d06/247343d0657844469f2bbc8932e4fa58.jpg)

Помимо подсветки синтаксиса есть еще такие удобные функции как:

### [TestRPC](https://github.com/ethereumjs/testrpc)

Последним инструментом, описанным в этой статье, будет TestRPC. 

## Solidity

Возможно вы слышали про то, что можно писать контракты не только на Solidity, но и на других языках, например [Serpent](https://github.com/ethereum/wiki/wiki/Serpent). Но последний комит в develop ветке [ethereum/serpent](https://github.com/ethereum/serpent/tree/develop) был примерно полгода назад, так что по видимому язык, увы, deprecated.

Пока что будем пользоваться Solidity. Пока что язык находится на относительно раннем этапе развития, поэтому никаких сложных конструкций или уникальных абстракций в нем нет. Для примера рассмотрим самый простой контракт, который содержит в себе, наверное, больше половины всех возможных тонкостей:

## Примеры контрактов

## Создаем контракт-визитку

Самое время создать наш контракт. В конечном итоге это будет приложение-визитка, на которую мы поместим форму обратной связи для соискателей, базовую информацию об авторе, список проектов и так далее.

### Шаблон

Первым делом создадим шаблон контракта и *функцию-конструктор*. Она должна называться также как и сам контракт и вызывается лишь однажды - при загрузке контракта в блокчейн. Мы будем использовать ее для инициализации таких базовых переменных как: имя, возраст, почта, страна и город.

```javascript
pragma solidity ^0.4.0;

contract EthereumCV {
    mapping (bytes32 => bytes32) basic_data;
    address owner;

    // =====================
    // ==== CONSTRUCTOR ====
    // =====================
    function EthereumCV(
        bytes32 name,
        bytes32 age,
        bytes32 email,
        bytes32 country,
        bytes32 city
    ){
        basic_data["name"] = name;
        basic_data["age"] = age;
        basic_data["email"] = email;
        basic_data["country"] = country;
        basic_data["city"] = city;

        owner = msg.sender;
    }
}
```

Вы можете видеть, что помимо уже названных переменных я ввел еще одну - `address owner`. Как вы уже наврное догадались, в нее записывается адрес того, кто залил контракт в сеть. А использоваться она будет для реализации функций администрирования (добавить / удалить проект), но об этом позже.

### Модульность

Следующим шагом создадим несколько *структур*, для описания проектов, образования и, например, любимых цитат. Здесь все просто, структуры описываются точно так же как и в Си. Но вместо того, чтобы описывать их в текущем контракте, вынесем их в отдельный контракт (в новом файле!), а `EthereumCV` от него унаследуем. Тем самым мы сможем избежать огромных простыней кода и структурировать наш проект.

Для этого создадим новый файл `structures.sol` и контракт `Structures`. А уже внутри него опишем каждую из структур:

```javascript
pragma solidity ^0.4.0;

contract Structures {
    struct Project {
        bytes32 name;
        bytes32 description;
        int32 year_start;
        int32 year_finish;
    }
    
    struct Education {
        bytes32 name;
        bytes32 speciality;
        int32 year_start;
        int32 year_finish;
    }
    
    struct Quotes {
        bytes32 author;
        bytes32 quote;
    }
}
```

Теперь осталось только импортировать полученный файл и унаследовать наш главный контракт от `Structures`. Для этого достаточно добавить всего пару строк:

```javascript
pragma solidity ^0.4.0;

import "structures.sol";

contract EthereumCV is Structures{
    mapping (bytes32 => bytes32) basic_data;
    address owner;

    Project[] projects;
    Education[] educations;
    Quote[] quotes;
	// ...
}
```

**BTW** На всякий случай отмечу, что помимо локального файла, Remix умеет импортировать `.sol` файлы по ссылке на Github и даже [с помощью протокола Swarm](https://www.reddit.com/r/ethereum/comments/5vpm53/remix_can_now_import_files_via_swarm/) (это что-то вроде распределенного хранилища для Ethereum, подробнее [здесь](http://ethereum.stackexchange.com/questions/375/what-is-swarm-and-what-is-it-used-for))

### Функции

## Добавляем UI

## Ссылки

- [A 101 Noob Intro to Programming Smart Contracts on Ethereum](http://consensys.github.io/developers/articles/101-noob-intro/)
- [MetaMask](https://medium.com/metamask/metamask-ff7d3571f331)
- [MetaMask 3 Migration Guide](https://medium.com/metamask/metamask-3-migration-guide-914b79533cdd)
- [Learning Solidity Part 1: Contract Dev with MetaMask](https://karl.tech/learning-solidity-part-1-deploy-a-contract/)
- [Learning Solidity Part 2: Commit-Reveal Voting](https://karl.tech/learning-solidity-part-2-voting/)
- [How to use MetaMask](https://www.cryptocompare.com/wallets/guides/how-to-use-metamask/)
- [Building an “Oracle” for an Ethereum contract](https://medium.com/@mustwin/building-an-oracle-for-an-ethereum-contract-6096d3e39551)
- [Full Stack Hello World Voting Ethereum Dapp Tutorial — Part 1](https://medium.com/@mvmurthy/full-stack-hello-world-voting-ethereum-dapp-tutorial-part-1-40d2d0d807c2)
- [Full Stack Hello World Voting Ethereum Dapp Tutorial — Part 2](https://medium.com/@mvmurthy/full-stack-hello-world-voting-ethereum-dapp-tutorial-part-2-30b3d335aa1f)