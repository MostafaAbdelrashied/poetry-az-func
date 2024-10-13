from scipy.optimize import minimize

from src.optimization.objective import objective


def main():
    result = minimize(objective, x0=0)
    return result
