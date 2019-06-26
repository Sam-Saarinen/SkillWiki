import sys
import GPy
import numpy as np

# Test script locally
# Simple Gaussian estimate for each action
#   Compute mean and standard error for each resource based on all interactions

# =>Update the Gaussian process (using Bayes' rule and past observations) to get new means and standard errors
# =>Okay to load all data in to model so that we're not storing model somewhere
# =>Feed user context vector to the Gaussian process
# =>Sample expected reward/mean and record as a tuple in an array

def main():
    # Gaussian Process for one resource

    # sample inputs and outputs
    # X = np.random.uniform(1.0,5.0,(50,2)) # From all (e.g. 50) interactions for this resource
    # Y = np.random.uniform(1.0, 5.0, (50,1)) # Helpfulness ratings from each interaction.

    X = np.zeros(shape=(6,2)) # Speed in 1st column, Guide in 2nd column
    Y = np.zeros(shape=(6,1)) # Helpfulness ratings

    # More thorough and guided students find this resource more helpful
    # X[0] = [3,5]
    # X[1] = [4,5]
    # X[2] = [5,5]
    # X[3] = [2,1]
    # X[4] = [1,2]
    # X[5] = [1,1]
    #
    # Y[0] = [4]
    # Y[1] = [4]
    # Y[2] = [5]
    # Y[3] = [2]
    # Y[4] = [1]
    # Y[5] = [1]

    # Faster and more self-directed students find this resource more helpful
    # X[0] = [3,5]
    # X[1] = [4,5]
    # X[2] = [5,5]
    # X[3] = [2,1]
    # X[4] = [1,2]
    # X[5] = [1,1]
    #
    # Y[0] = [3]
    # Y[1] = [1]
    # Y[2] = [2]
    # Y[3] = [4]
    # Y[4] = [5]
    # Y[5] = [5]

    # More thorough and self-directed students find this resource more helpful
    # X[0] = [4,1]
    # X[1] = [3,4]
    # X[2] = [5,5]
    # X[3] = [4,2]
    # X[4] = [1,4]
    # X[5] = [1,1]
    #
    # Y[0] = [5]
    # Y[1] = [3]
    # Y[2] = [2]
    # Y[3] = [4]
    # Y[4] = [2]
    # Y[5] = [3]

    # Students in the middle find this resource more helpful
    X[0] = [4,1]
    X[1] = [2,4]
    X[2] = [3,4]
    X[3] = [2,3]
    X[4] = [1,4]
    X[5] = [1,1]

    Y[0] = [2]
    Y[1] = [3]
    Y[2] = [5]
    Y[3] = [4]
    Y[4] = [2]
    Y[5] = [1]


    # define kernel
    ker = GPy.kern.RBF(input_dim=2, variance=1., lengthscale=1.)

    # create GP model
    m = GPy.models.GPRegression(X,Y, ker) # Set prior mean to 2.5

    # optimize
    m.optimize(messages=True)

    # sample mean
    user_features = np.array([1,1])
    user_features = np.reshape(user_features, (1,2))
    mean_reward, mean_var = m.predict(user_features)

    print("Mean: " + str(mean_reward[0][0]))
    print("Standard error: " + str(np.sqrt(mean_var[0][0]) / X.shape[0])) # Not the actual standard error
    sample_mean = np.random.normal(loc=mean_reward[0][0], scale=np.sqrt(mean_var[0][0]) / X.shape[0])
    print("Sample mean: " + str(sample_mean))
    return sample_mean
    # Mean is a 1 by 2 array?
    # Standard error is the square root of the only element of mean_var divided by the number of data points
    # Need to get standard error and then sample from distribution with noisy mean
    # Specific command for standard error? (Maybe spend 1-2 hours only)
    # return mean_reward # this is a 3-d array

if __name__ == "__main__":
    main()
