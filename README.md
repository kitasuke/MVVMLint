# MVVMLint

A linter tool for data flow of MVVM architecture using [SwiftSyntax](https://github.com/apple/swift-syntax).

## Target architectures

### Enum approach

```swift
public protocol ViewModelType {
    associatedtype Inputs
    associatedtype Outputs

    func apply(_ inputs: Inputs)
    var outputsObservable: Observable<Outputs> { get } // Observable is custom type
}
```

```swift
class FooViewModel: ViewModelType {
    enum Inputs {
        case viewDidLoad
        case buttonTapped(Data)
        case unusedInput // this case is defined in view model, but never used in view controller
    }

    enum Outputs {
        case reloadData
        case showError(Error)
        case unusedOutput
    }
}
```

```swift
class FooViewController {
    var viewModel: FooViewModel
    func viewDidLoad() {
        viewModel.apply(.viewDidLoad)
    }
    func buttonTapped() {
        viewModel.apply(.buttonTapped(data))
    }
    func bindViewModel() {
        viewModel.outputsObservable.subscribe { output in
            switch output {
            case .reloadData: break
            case .showError(let error): break
            case .set(let number): break
            }
        }
    }
}
```

### Protocol approach

```swift
protocol FooViewModelInputs {
    func viewDidLoad()
    func buttonTapped(data: Data)
    func unusedInput() // this function is defined in view model, but never used in view controller
}
protocol FooViewModelOutputs {
    var reloadData: (() -> Void)? { get set }
    var showError: (() -> Error)? { get set }
    var unusedOutput: (() -> Void)? { get set }

    var title: String? { get }
}
protocol FooViewModelType {
    var inputs: FooViewModelInputs { get }
    var outputs: FooViewModelOutputs { get }
}
class FooViewModel: FooViewModelInputs, FooViewModelOutputs, FooViewModelType {...}
```

```swift
class FooViewController: FooViewModelType {
    var viewModel: FooViewModel
    func viewDidLoad() {
        view.apply(viewModel.outputs.title)

        viewModel.inputs.viewDidLoad()
    }
    func buttonTapped() {
        viewModel.inputs.buttonTapped(data)
    }
    func bindViewModel() {
        viewModel.outputs.reloadData = { _ in }
        viewModel.outputs.showError = { _ in Error() }
    }
}
```

## Requirements

Swift 5.0+  
Xcode 11.0+  

## How to use

### Installation

Run below command

```terminal
$ make install
$ mvvmlint help
```

### Available Commands

#### `help`

Display general or command-specific help

#### `run --paths <path,path...>`

Display unused identifiers

## Examples

```terminal
$ mvvmlint run --paths "~/dev/"
input: viewDidLoad not called at: ~/dev/xxx.swift
output: showHUD not called at: ~/dev/zzz.swift
output: dismissHUD not called at: ~/dev/zzz.swift
```

## TODOs

- [ ] Same identifier, but different label
- [ ] Same identifier and same type
- [ ] Combine usage

## Acknowledgements

- [swift-ast-explorer-playground](https://github.com/kishikawakatsumi/swift-ast-explorer-playground)
