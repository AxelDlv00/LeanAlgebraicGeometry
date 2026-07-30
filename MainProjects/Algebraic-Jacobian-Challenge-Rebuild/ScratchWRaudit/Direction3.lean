import Mathlib
#check @Module.finrank_zero_iff
-- control: is it true WITHOUT Module.Finite? (an infinite-dim space with finrank 0)
example (K M : Type) [Field K] [AddCommGroup M] [Module K M] (h : Module.finrank K M = 0) :
    Subsingleton M := by
  exact (Module.finrank_zero_iff (R := K)).mp h
