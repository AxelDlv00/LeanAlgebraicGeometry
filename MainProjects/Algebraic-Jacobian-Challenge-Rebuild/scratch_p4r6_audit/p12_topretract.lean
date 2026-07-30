import AlgebraicJacobian.Picard.Pic0ChartSeamCollapse

theorem controlSorry : True := by sorry
#print axioms AlgebraicGeometry.Jacobian

-- CLAIM UNDER AUDIT (docstring of exists_retraction_of_seam): a continuous left inverse
-- on all of X forces V to "meet every connected component".  REFUTATION in pure topology.
example : ∃ (V : Set Bool) (r : Bool → V), Continuous r ∧ (∀ v : V, r v.1 = v) ∧
    ∃ x : Bool, ¬ (connectedComponent x ∩ V).Nonempty := by
  refine ⟨{true}, fun _ => ⟨true, rfl⟩, continuous_of_discreteTopology, ?_, false, ?_⟩
  · rintro ⟨v, rfl | -⟩ <;> rfl
  · rintro ⟨y, hy1, hy2⟩
    have : y = true := hy2
    subst this
    have : connectedComponent (false : Bool) = {false} := by
      simpa using (connectedComponent_eq_singleton (false : Bool))
    rw [this] at hy1
    exact Bool.noConfusion (hy1 : (true : Bool) = false)
