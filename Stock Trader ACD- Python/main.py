# Author: Jaber Daneshamooz
from time import sleep

from NWebservices import NWebservice

print('Start ACD Project...')
print('Enter -1 to Exit')

import pandas as pd
from tehran_stocks import get_all_price, Stocks, update_group, db

# pd.set_option("display.max_rows", None, "display.max_columns", 500)
# pd.set_option('display.width', 1000)

# get_all_price() # download and(or) update all prices
# update_group(34) #download and(or) update Stocks in groupCode = 34 (Cars)

# Stocks.get_group() # to see list of group codes
# for i in Stocks.query.filter():
#     print(i)
# stock = Stocks.query.filter(Stocks.title.like('%گهر%')).first()
# print(stock.df)
# stock.df
# stock.summary()
ws= NWebservice()
while True:
    print('')
    sleep(1)
    input_date = input("Enter Date Between 13970101 to 13971230: ")
    if input_date == '-1':
        break
    input_company_id = input("Enter Company ID ( like 351 for IKCO ): ")
    if input_company_id == '-1':
        break
    if not input_date.startswith('1397'):
        print('Invalid Date')
        continue
    if input_company_id == '':
        print('Invalid Company ID')
        continue
    ws.get_history_price(date=input_date, company_id=input_company_id)

print('ACD Project Finished...!')
