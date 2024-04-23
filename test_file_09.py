import pandas as pd


credit_card_df = pd.read_csv('test.csv')
credit_card_label_df = pd.read_csv('Credit_card_label.csv')


credit_card_df.head()
credit_card_label_df.head()


credits_df = pd.merge(credit_card_df, credit_card_label_df, on='Ind_ID')


credits_df.head()

credits_df.to_csv('merged_credit_data.csv', index=False)

credits_df