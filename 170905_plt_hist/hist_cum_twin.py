"""Example to show how to plot histogram with accumulate ratio."""
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

% matplotlib inline
sns.set(style="darkgrid", palette="muted", color_codes=True)

# Toy data
np.random.seed(0)
dt = np.random.normal(size=100)

fig, ax1 = plt.subplots()

# Plot histogram and get bin info
n, bins, patches = ax1.hist(dt, alpha=0.7, label='Frequency')

# Add 1st y label
ax1.set_ylabel('Frequency')

# Get values plot with secondary axis

# Calc cumulative ratio
y2 = np.add.accumulate(n) / n.sum()

# Calc moving average
x2 = np.convolve(bins, np.ones(2) / 2, mode="same")[1:]

# Plot with secondary axes
ax2 = ax1.twinx()
lines = ax2.plot(x2, y2, ls='--', color='r', marker='o',
         label='Cumulative ratio')
ax2.grid(visible=False)

# Add 2nd y label
ax2.set_ylabel('Cumulative ratio')

# Add Legend
plt.legend(handles=[patches[0], lines[0]])

plt.savefig('fig.png', dpi=150)
plt.show()
