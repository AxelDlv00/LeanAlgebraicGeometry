# Brick spec — ζ2·ii-a: the tensor-Away double-cover algebra (G1–G3, G7)

*Written 2026-07-13 (Fable), from `informal/zeta2ii-api-recon.md` (READ IT FIRST — §3, §5).
Consumer: one Opus implementation agent. Pure algebra; NO dependence on the in-flight
`CoherentWitness*` files (another agent owns those — do not open them for writing).*

## Mission

Build the algebra layer that ζ2·ii's pi-assembly needs, as reusable, mathlib-quality
infrastructure. Four deliverables, in dependency order (G-numbers from the recon):

### G1 (keystone): tensor of Away models is an Away model over the tensor

New file `AlgebraicJacobian/Algebra/TensorAway.lean`. For `A → B` a `CommRing`/`Algebra`
tower, `r s : B`, `Si Sj` with `[IsLocalization.Away r Si]`, `[IsLocalization.Away s Sj]`
(both over `B`):

- the canonical `Algebra (B ⊗[A] B) (Si ⊗[A] Sj)` structure
  (`Algebra.TensorProduct.map (algebraMap-as-AlgHom over A) …`; manage instances with the
  care of the project's `tensor'` idiom — `Algebra/PiLocalization.lean:301` — prefer
  explicit local `letI`/defs over global instances if a diamond threatens, but the final
  API should expose ONE canonical instance-or-def with `IsScalarTower A (B ⊗[A] B)
  (Si ⊗[A] Sj)` etc. as needed downstream),
- `theorem isLocalization_away_tensor : IsLocalization.Away
    ((r ⊗ₜ 1) * (1 ⊗ₜ s) : B ⊗[A] B) (Si ⊗[A] Sj)` (spelling of the element up to you:
  `includeLeft r * includeRight s` is equivalent — pick the form that rewrites best and
  provide a `simp`-normal statement),
- `noncomputable def tensorAwayEquiv … : (Si ⊗[A] Sj) ≃ₐ[B ⊗[A] B] Tij` for any other
  model `[IsLocalization.Away ((r ⊗ₜ 1) * (1 ⊗ₜ s)) Tij]` (one line via
  `IsLocalization.algEquiv` once G1 holds), with `tensorAwayEquiv_tmul`-style apply
  lemmas for pure tensors (needed by G3/G5 consumers).

Proof route (recon-verified primitives): `IsLocalization.Away.tensor`
(mathlib `RingTheory/Localization/BaseChange.lean:447`) for the base change
`B → B ⊗[A] B` (via `includeLeft`) of `Si` — note `(B ⊗[A] B) ⊗[B] Si ≃ Si ⊗[A] B`
(associativity/comm isos of `Algebra.TensorProduct`) — then `IsLocalization.Away.mul'`
(mathlib `…/Away/Basic.lean:288`) to invert the second element. Transport `IsLocalization`
along the `AlgEquiv` (`IsLocalization.isLocalization_of_algEquiv`). SEARCH mathlib once
more before assembling (lean_loogle: `IsLocalization.Away _ (_ ⊗[_] _)`) — if a one-shot
lemma exists after all, use it and say so.

### G2: pi-double / pi-triple decompositions for the A-tower

Same or second file (`Algebra/TensorAwayPi.lean` if G1's file would exceed ~350 lines).
`ι` a `Fintype`, `f : ι → B` with models `S i` (`Away (f i)` over `B`), `P := ∀ i, S i`,
`T p := S p.1 ⊗[A] S p.2`:

- `noncomputable def piDoubleEquivA : (P ⊗[A] P) ≃ₐ[A] ∀ p : ι × ι, T p` —
  `Algebra.TensorProduct.piPiAlgEquiv A S S` (exists, `Algebra/PiLocalization.lean:262`);
  compose with per-component identity; provide the `_tmul` apply lemma.
- the triple analogue `piTripleEquivA : (P ⊗[A] (P ⊗[A] P)) ≃ₐ[A] ∀ t : ι × ι × ι, W t`
  with `W t := S t.1 ⊗[A] (S t.2.1 ⊗[A] S t.2.2)` — compose `piPiAlgEquiv` twice
  (no cube lemma exists); `_tmul` apply lemma.

### G3: transport of the descent faces/inclusions through G2

Analogues, for the A-tower, of `piTripleEquiv_descentFace₂₃/₁₂/₁₃`,
`piDoubleEquiv_descentIncl₁/₂`, `lmul'_piDoubleEquiv_symm`
(`Algebra/LocalizationCocycle.lean:290/322/355` etc. — read them and mirror statements):

- `piDoubleEquivA_descentIncl₁/₂` — `Module.descentIncl` (from `Descent/UnitDescent.lean`)
  becomes the index-wise inclusion,
- `piTripleEquivA_descentFace₁₂/₁₃/₂₃` — the three `Module.descentFace`s become index-wise
  maps `T (i,k) → W (i,j,k)` etc.,
- `lmul'_piDoubleEquivA_symm` — multiplication corresponds to the diagonal.

CRITICAL proof-route constraint (recon §5-G3): `AlgHom.ext_of_isLocalization_pi` over `A`
does NOT apply (components are not Away-over-`A`). Either (i) run pi-ext over `B ⊗[A] B`
after G1 makes components Away over it — the faces ARE `B ⊗[A] B`-algebra maps in the
appropriate sense — or (ii) prove by `piPiAlgEquiv_tmul` + pure-tensor computation
(`TensorProduct.induction_on`/`ext`). Pick whichever elaborates; (ii) is dumber but safe.

### G7: faithful-flatness plumbing for the tower `A → B → P`

- `Module.FaithfullyFlat A P` from `[Module.FaithfullyFlat A B]` + the covering-family
  hypothesis (`Module.FaithfullyFlat.trans` + the existing
  `BasicRefinement.faithfullyFlat` / `IsLocalization.AwayCover` FF lemmas — recon §1A/§5-G7;
  package the exact instance(s) ζ2·ii-b will need, stated for this tower, with a short
  docstring saying it is the (C1) composite-cover tower).

## Constraints

- Mathlib naming/conventions throughout (mathlib-conventions skill); full docstrings; the
  file(s) must read as PR-extractable general infrastructure — nothing (C1)-specific in
  statements (no mention of curves/witnesses); ≤ 500 lines per file.
- `set_option autoImplicit false`; universe-polymorphic where free.
- Wire new files into `AlgebraicJacobian.lean` (aggregator). ANOTHER AGENT is concurrently
  editing that file: before saving, re-read it, and re-apply ONLY your import lines; if
  your edit fails on staleness, re-read and retry (never overwrite others' lines).
- Do NOT open `Picard/CoherentWitness.lean` / `Picard/CoherentWitnessExists.lean` for
  writing. Do NOT touch `Challenge.lean`. No new axioms, no `sorry` in the final state.
- Search before proving every nontrivial step (lean_local_search / lean_loogle /
  lean_leansearch); the recon's negative-grep list (§ end) is a starting point, not proof
  of absence.

## Verification (FOREGROUND, non-negotiable)

1. `lake build` from the project root; BLOCK until it finishes; paste the tail.
2. `lean_verify` on `isLocalization_away_tensor` (or final name) and each G3 lemma:
   axioms exactly `[propext, Classical.choice, Quot.sound]`.
3. `grep -n -w sorry` on every touched file (expect zero matches; grep exits 1 then).

## Report format (final message)

Files created (line counts) · declarations with one-line statements · which proof route
G3 took and why · build tail verbatim · lean_verify output verbatim · deviations ·
anything the ζ2·ii-b spec-writer must know (especially the exact spelling of the G1
element and the `Algebra (B ⊗[A] B) (Si ⊗[A] Sj)` structure you settled on).
