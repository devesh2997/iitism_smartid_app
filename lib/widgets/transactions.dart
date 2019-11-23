import 'package:flutter/material.dart';
import 'package:iitism_smartid_app/data/transactions_repository.dart';
import 'package:iitism_smartid_app/models/transaction.dart';
import 'package:iitism_smartid_app/utils/index.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TransactionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    TransactionRepository transactionRepository =
        Provider.of<TransactionRepository>(context);
    Status status = transactionRepository.status;
    List<Transaction> transactions = transactionRepository.transactions;
    return ListView(
      children: <Widget>[
        Container(
          height: 150,
          color: Colors.transparent,
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Transactions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    )
                  ],
                ),
              ),
              if (status == Status.Uninitialized || status == Status.Loading)
                Container(
                  height: 200,
                )
              else if (status == Status.Error)
                Text('Some error occurred.')
              else if (status == Status.NotAuthenticated)
                Text('You need to be signed in to view the transactions')
              else if (transactions.length == 0)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      SvgPicture.asset(
                        'assets/images/empty.svg',
                        width: size.width * 0.75,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'You have made no payments till now.',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                )
              else
                for (int i = 0; i < transactions.length; i++)
                  TransactionTile(
                    transaction: transactions[i],
                  ),
            ],
          ),
        ),
      ],
    );
  }
}

class TransactionTile extends StatelessWidget {
  final Transaction transaction;

  const TransactionTile({Key key, this.transaction}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    String description = "";
    Widget trailing;
    switch (transaction.type) {
      case TransactionType.CREDIT:
        description = "Added to SmartID";
        trailing = Text(
          '+ ' + '\u20B9' + transaction.amount.toString(),
          style: TextStyle(
            color: hexToMaterialColor('#00C853'),
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        );
        break;
      case TransactionType.DEBIT:
        description = "Paid for order at " + transaction.merchant.businessName;
        trailing = Text(
          '- ' + '\u20B9' + transaction.amount.toString(),
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
          ),
        );
        break;
      default:
    }

    return Column(
      children: <Widget>[
        ListTile(
          leading: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade100,
            ),
            child: Icon(
              Icons.call_received,
              color: hexToMaterialColor('#00C853'),
            ),
          ),
          title: Text(
            description,
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          trailing: trailing,
          subtitle: Text(
            toDateString(transaction.time) +
                ' , ' +
                toTimeString(transaction.time),
          ),
        ),
        Divider(),
      ],
    );
  }
}
