# lean-auditor directive — iter-213

## Files to audit (read these in full)

- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean`

This is the only `.lean` file that received prover work this iteration. Audit it as Lean,
with no assumption about what the strategy claims should be true.

## Focus areas

1. **Stale docstrings vs. actual proof bodies.** The declaration
   `AlgebraicGeometry.Scheme.Modules.tensorObj_assoc_iso` (around line 659) was rewritten
   this iter into a complete 3-step composite proof. Read its preceding docstring
   (roughly lines 620–658) against the body. Report any place where the docstring
   describes a different construction, a different residual, or a stale "iter-NNN status"
   than what the body actually does.

2. **Unused hypotheses / over-broad signatures.** Check whether `tensorObj_assoc_iso`'s
   hypotheses (`hM hN hP : LineBundle.IsLocallyTrivial …`) are actually consumed by the
   body. If they are dead, flag whether the signature should be slimmed or whether keeping
   them is justified (e.g. matching a frozen/blueprint signature).

3. **The new residual `isLocallyInjective_whiskerLeft_of_W` (around line 411–419)** — a
   `sorry`-bodied lemma. Assess: is its stated type substantive and correctly quantified
   (arbitrary `F`, `g` with `J.W (toPresheaf g)` ⟹ `IsLocallyInjective J (F ◁ g)`), or is
   it a vacuous/overfit statement that merely makes downstream code typecheck? Is the
   docstring's mathematical justification (stalkwise `id ⊗ iso`) coherent?

4. **New closed helpers** `W_whiskerLeft_of_W`, `W_whiskerRight_of_W` (around 427–452) —
   verify they are genuine proofs, not disguised `sorry`s, and that the braiding-conjugate
   argument in `W_whiskerRight_of_W` is sound.

5. General: outdated comments, dead-end proofs, suspicious `letI`/`inferInstanceAs` carrier
   bridges (line ~669), bad Lean practices, leftover scaffolding comments referencing
   abandoned routes.

6. Pre-existing off-path `sorry`s at lines ~829 (`tensorObj_restrict_iso`), ~872
   (`exists_tensorObj_inverse`), ~911 (`addCommGroup_via_tensorObj`) — note their status but
   they are known/expected; focus your critical energy on items 1–5.

## Output

Per-declaration checklist + a flagged-issues block with severities (CRITICAL/HIGH/MEDIUM/LOW).
