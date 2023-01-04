import requests
import static as static
from requests.auth import HTTPBasicAuth
import json


class NWebservice():
    def __init__(self):
        self.tokenURL = "https://data3.nadpco.com/api/v2/Token"
        self.StocksURL = "https://data3.nadpco.com/api/v3/TS/DailyTrades"
        self.historyURL = "https://data3.nadpco.com/api/v3/TSH/RealTimeTrades/"
        self.username = "demoTS2"
        self.password = "hy89njh"
        self.token = ""
        self.txtprice = ""

    def get_history_price_test(self, date=None, company_id=None):

        if not self.read_token():
            print("WebService is Not Available now!")
            return
        url = self.historyURL
        history_list = []
        if date is not None and company_id is not None:
            url = url + str(company_id) + '?date=' + str(date)
            headers = {"Authorization": "Bearer " + self.token}
            # response = requests.get(url, headers=headers)
            response = self.txtprice
            # if response.status_code == 500:
            #     print('Invalid Token! Try Again!')
            #     token = getToken()
            # print(response.status_code)
            # if response.status_code == 200:
            # res = json_data = json.loads(response.text)
            res = json_data = json.loads(response)
            for i in res:
                a, b = i['tradeDateGre'].split('T')
                i['tradeDate'] = i['tradeDate'] + ' ' + b
                x = (i['maxPrice'] + i['minPrice']) / 2
                y = (i['maxPrice'] + i['minPrice'] + i['closingPrice']) / 3
                w = abs(x - y)
                pivot_l = y - w
                pivot_h = y + w

                tmp = {
                    "date": i['tradeDate'],
                    "lastPrice": i['lastPrice'],
                    "maxPrice": i['maxPrice'],
                    "minPrice": i['minPrice'],
                    "openingPrice": i['openingPrice'],
                    "closingPrice": i['closingPrice'],
                    "PivotL": pivot_l,
                    "PivotH": pivot_h
                }
                history_list.append(tmp)
            for i in history_list:
                print(i)


        else:
            print('Invalid Input!')
            return

    def get_history_price(self, date=None, company_id=None):
        print('Start Getting StockShare Price History ... ')
        if not self.read_token():
            print("WebService is Not Available now!")
            return
        url = self.historyURL
        history_list = []
        if date is not None and company_id is not None:
            url = url + str(company_id) + '?date=' + str(date)
            headers = {"Authorization": "Bearer " + self.token}
            response = requests.get(url, headers=headers)
            if response.status_code == 500:
                print('Invalid Token! Try Again!')
                self.token = self.get_token()
            if response.status_code == 200:
                res = json_data = json.loads(response.text)
                for i in res:
                    a, b = i['tradeDateGre'].split('T')
                    i['tradeDate'] = i['tradeDate'] + ' ' + b
                    x = (i['maxPrice'] + i['minPrice']) / 2
                    y = (i['maxPrice'] + i['minPrice'] + i['closingPrice']) / 3
                    w = abs(x - y)
                    pivot_l = y - w
                    pivot_h = y + w

                    tmp = {
                        "date": i['tradeDate'],
                        "lastPrice": i['lastPrice'],
                        "maxPrice": i['maxPrice'],
                        "minPrice": i['minPrice'],
                        "openingPrice": i['openingPrice'],
                        "closingPrice": i['closingPrice'],
                        "PivotL": pivot_l,
                        "PivotH": pivot_h
                    }
                    history_list.append(tmp)
                for i in history_list:
                    print(i)


        else:
            print('Invalid Input!')
            return

    def get_all_stocks_price(self, date=None, company_id=None):
        global token
        if not self.read_token():
            print("WebService is Not Available now!")
            return
        url = self.StocksURL
        if date is not None and company_id is not None:
            url = url + '?date=' + str(date) + "&companyId=" + str(company_id)
        elif date is not None:
            url = url + '?date=' + str(date)
        headers = {"Authorization": "Bearer " + token}

        response = requests.get(url, headers=headers)

        if response.status_code == 500:
            print('Invalid Token! Try Again!')
            self.token = self.get_token()

        print(response.text)
        if response.status_code == 200:
            res = json.loads(response.text)
            for i in res:
                a, b = i['tradeDateGre'].split('T')
                i['tradeDate'] = i['tradeDate'] + ' ' + b
                print(i['tradeDate'])

    def get_token(self):
        response = requests.post(self.tokenURL, auth=HTTPBasicAuth(self.username, self.password)).text
        # response = requests.post(self.tokenURL, auth=HTTPBasicAuth('username', 'password'))

        # response = '{"token": "BF9FD1A50BCC5474BD35DF90088D6D335C24E10AA623C4892C0D035513D5C9F61E6FE02EDA8B9E8C00ACB4896533C58769E815584601A0A15B88292A1C289F3C"}'

        # res = json_data = json.loads(response.text)
        res = json_data = json.loads(response)


        f = open("token.txt", "w")
        f.write(res['token'])
        f.close()
        f = open("token.txt", "r")
        f.close()
        print('new token : ' + str(res['token']))
        return res['token']

    def read_token(self):

        try:
            t = open("ikco13970820.txt", "r")
            self.txtprice = t.read()
            t.close()
        except:
            print('Error in reading file')

        try:
            f = open("token.txt", "r")
            self.token = f.read()
            f.close()
        except Exception as e:
            if str(e) == "[Errno 2] No such file or directory: 'token.txt'":
                self.token = self.get_token()
        if self.token != "":
            return True
        else:
            return False

    # print('Start')
    #
    # read_token()
    # # get_all_stocks_price(date=13971113, companyID=351)
    # # get_history_price_test(date=13971113, company_id=351)
    # # print('token : ' + token)
    # print('End')
