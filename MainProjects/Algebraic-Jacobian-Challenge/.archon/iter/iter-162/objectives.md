# Iter-162 objectives detail

## Lane 1 — `AlgebraicJacobian/AbelianVarietyRigidity.lean` (single DEEP lane)

**Target:** close the lone Step-1 residual `rigidity_eqAt_closedPoint_of_proper_into_affine`
(decl L204, body `sorry` L263). After this the entire Rigidity-Lemma chain is axiom-clean.

**State entering iter-162** (verified on disk + iter-161 prover/auditor reports):
- The body already reduces the residue-field-probe goal (via `cancel_epi` on the residue-field iso +
  `suffices`) to the k̄-point equation `q ≫ f.left = q ≫ retract.left ≫ f.left`, with
  `q := pointOfClosedPoint … ≫ U.ι` established as a section of `(X⊗Y).hom` (`hqsec`).
- The algebraic heart `eq_comp_of_isAffine_of_properIntegral` (L153) is PROVEN axiom-clean.
- Verified instances at the residual: `UniversallyClosed X.hom` ✓, `LocallyOfFiniteType X.hom` ✓.
  Only `IsIntegral X.left` is missing for the sub-lemma application.

**Remaining work (recipe — `analogies/rigidity-affineconst.md`, blueprint Step-1 + the two new nodes):**
1. Named helper `IsIntegral X.left` (blueprint `lem:isIntegral_of_retract_of_integral`): `X.left` a
   retract of the integral `(X⊗Y).left` via section `s` of `p₁`. Irreducible = continuous image of
   irreducible under surjective `p₁`; reduced = split-injective `p₁.appTop` into reduced ⟹
   `isReduced_of_injective` [verified `AlgebraicGeometry/Properties.lean`]. Land as a clean top-level
   decl; fill the blueprint `\lean{}` cross-ref afterward (flagged in a `% NOTE:` there).
2. `ŷ : 𝟙_ ⟶ Y` lifting `y := q ≫ (snd X Y).left` (section of `Y.hom` via `Over.w (snd X Y)` + `hqsec`);
   slice section `s := lift (𝟙 X) (toUnit X ≫ ŷ)`.
3. Corestrict `(s ≫ f).left` to `U₀.toScheme` (`IsOpenImmersion.lift`, range bound from `_hfU` + `_hUV`),
   apply `eq_comp_of_isAffine_of_properIntegral` to the k̄-points `q ≫ p₁` and `x₀.left`.
4. Two pullback-`hom_ext` identities `q = (q ≫ p₁) ≫ s`, `retract.left ∘ q = x₀.left ≫ s` — mirror the
   closed `hfib` `IsPullback`-pasting idiom in `rigidity_eqOn_dense_open`.

**PARTIAL acceptance:** acceptable if (1)–(4) don't all land; land each new step as a clean named
top-level `sorry`-decl. **iter-163 progress-critic tripwire:** the lane must close the residual OR land
a named axiom-clean sub-lemma (e.g. `IsIntegral X.left`) — an empty PARTIAL flips the route to CHURNING.

**Hard constraints:** no protected-signature changes; no edits to the five chain signatures (carry
`[IsAlgClosed kbar]` + `[LocallyOfFiniteType (X⊗Y).hom]`); no touching the 3 deferred scaffolds
(L663/687/712) or the already-proven chain lemmas; no new axioms (`lean_verify` must stay
`{propext, Classical.choice, Quot.sound}` modulo the transitive `sorryAx` while the residual is open).

## Blueprint gate
`AbelianVarietyRigidity.tex` — `complete:true + correct:true`, HARD GATE CLEARS (blueprint-reviewer
`iter162b`). The Step-1 lane is fully blueprinted (both new nodes cover exactly the residual's content).

## NOT this iter
Theorem of the cube (blueprint OR prover) — base-case route re-opened, gated on the iter-163
verification. Jacobian/RigidityKbar, RR bridge, Route A — gated.
