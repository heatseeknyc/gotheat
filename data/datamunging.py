# Transformations performed on the data:

# Beginning with the raw complaints data, we merged with the housing
# dataset "joined.csv" prepared by John Krauss, available at
# https://github.com/talos/nyc-stabilization-unit-counts

# Both datasets were indexed by the address and street name.
# Example: '996 CYPRESS AVENUE'

data = pd.merge(joined, complaints, left_index=True, right_index=True, how='left')

# Here we checked to see if the zip codes between the datasets lined up,
# to confirm that we were merging the correct buildings. Approximately 600
# addresses had inconsistent zip codes, which we removed from the dataset.

data = data[data.unitsres > 0] # Exclude buildings without residential units.
data['complaintrate'] = data['total'] / data['unitsres']
data['std'] = data[['2010', '2011', '2012', '2013', '2014', '2015']].std(axis=1)
data['total'] = data[['2010', '2011', '2012', '2013', '2014', '2015']].sum(axis=1)

# Then we created the various risk measures:

data['risk1'] = 0
data['risk2'] = 0
data['risk3'] = 0
data['risk4'] = 0
data['risk5'] = 0

# In [628]: len(data[data.total > 0]) / 5.
# Out[628]: 5631.8 # 20% of the dataset

# We ultimately went with twice this (40%) to create the risk4 label.

data[(data['total'] / data['std']) / data['unitsres'] > .48] # ~20% of complaint buildings
data.loc[_.index, 'risk1'] = 1

data[(data['total'] / data['std']) / np.sqrt(d['unitsres']) > 1.56] # ~20% of complaint buildings
data.loc[_.index, 'risk2'] = 1

data[(data['total'] / data['std']) / np.log(d['unitsres']) > 2.3] # ~20% of complaint buildings
data.loc[_.index, 'risk3'] = 1

data[(data['total'] / data['std']) / data['unitsres'] > .3] # ~40% of complaint buildings
data.loc[_.index, 'risk4'] = 1

data[(data['total'] / data['std']) / data['unitsres'] > .24] # ~50% of complaint buildings
data.loc[_.index, 'risk5'] = 1

# Ultimately, risk4 provided the most precise measure:

# AUC: 0.819
# Accuracy 0.768
# Precision 0.608
# Recall 0.458
# F1 Score 0.522