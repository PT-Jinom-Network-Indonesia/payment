# Payment
Snap for Jinom Payment
## Getting Started for Flutter

### Installation dependecies

Edit your pubspec.yaml

```yaml
dependencies:
    payment:
        git: 
            url: https://github.com/PT-Jinom-Network-Indonesia/payment.git
            ref: main
```

And run ``` flutter pub get```

### Using snap

```dart

import 'package:payment/payment.dart';
...

var token = "YOUR SNAP TOKEN";
var payment = Payment();
payment.pay(token);

...
```


### Using static virtual account number

```dart

import 'package:payment/payment.dart';
import 'package:payment/models/virtual_account.dart';
...

List<VirtualAccount> virtualAccounts = [
                            VirtualAccount(
                                bank: VirtualAccount.bri,
                                vaNumber: "083119030893",
                            )

                            // And Other Bank 
                        ];

var token = "YOUR SNAP TOKEN";
var payment = Payment();
payment.setVirtualAccounts(virtualAccounts);
payment.pay(token);

...
```