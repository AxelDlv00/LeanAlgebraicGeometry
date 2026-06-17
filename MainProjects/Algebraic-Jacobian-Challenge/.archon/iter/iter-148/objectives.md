# Iter-148 prover objectives — per-target detail

## Objective 1 — `AlgebraicJacobian/Cotangent/ChartAlgebra.lean`

Single file, 2 sorries in scope; ~230–400 LOC aggregate. Single
prover lane.

### Sub-target 1.A — KDM forward inclusion (L139)

Declaration:
`AlgebraicGeometry.KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero`
at L123–139.

**Current state** (post iter-147):
- Signature refined to the blueprint-mandated finite-type
  `k`-algebra form.
- Reverse inclusion `range algebraMap ⊆ ker D` closed via
  `Derivation.map_algebraMap` as named `_hRev`.
- Forward inclusion (substantive) is structured `sorry` at L139.

**Iter-148 closure path** — (p2) char-0 via
`Differential.ContainConstants` typeclass bridge:

The typeclass `Differential.ContainConstants` lives in
`Mathlib.RingTheory.Derivation.DifferentialRing`. It is positioned
for a specific derivation `B → B`, not the universal Kähler
derivation `D : B → Ω_{B/k}`. The bridge:

1. **Free basis of `Ω_{B/k}`.** Mathlib's
   `Algebra.IsStandardSmooth.free_kaehlerDifferential` [verified
   via `lean_loogle` — exists in `Mathlib.RingTheory.Smooth.StandardSmoothCotangent`]
   shows `Module.Free B Ω[B⁄k]` when `B` is standard-smooth over
   `k`. Pick an explicit basis `e₁, …, eₙ`.
2. **Coefficient derivations.** For each basis element `eᵢ`,
   project `D : B → Ω[B⁄k]` to the coefficient of `eᵢ` in the
   basis decomposition. This gives `∂ᵢ : B → B` — a `k`-derivation
   on `B` (verify the derivation axioms — Leibniz + additivity —
   carry through projection).
3. **`Differential B` instance.** Each `∂ᵢ` gives a `Differential B`
   instance whose `x'` corresponds to the `eᵢ` coefficient.
4. **Apply `ContainConstants`.** In characteristic 0, Mathlib's
   `Differential.ContainConstants` says `∂ᵢ b = 0` for all `i`
   iff `b ∈ range (algebraMap k B)`. The hypothesis `D b = 0`
   expanded in the basis gives `∂ᵢ b = 0` for each `i`; conclude
   `b ∈ range (algebraMap k B)`.

**Estimate**: ~80–150 LOC.

**Hypothesis shape**: iter-148 may ship with an explicit `[CharZero k]`
hypothesis on the declaration (the char-`p` case stays as a
documented structured sorry via case-split, or is deferred entirely
to iter-149+ which scaffolds the chart-of-proper-curve helper for
(p1) char-`p`).

**Order of attack**: Sub-target 1.A first (mechanical-flavoured
char-0 work; should land within budget). Frees mental budget for
Sub-target 1.B.

**Lemmas worth looking up before starting** (the prover, not the
planner, runs `lean_loogle` / `lean_leansearch`):
- `Differential.ContainConstants` — search for its exact
  signature shape and verify the typeclass requires nothing the
  bridge can't supply.
- `Module.Free.repr` / `Basis.repr` / similar — basis-coefficient
  projection.
- `Algebra.IsStandardSmoothOfRelativeDimension` — the hypothesis
  the bridge needs to upgrade `Algebra.FiniteType k B` to.

**Honesty rule**: if the bridge proves harder than 150 LOC,
PARTIAL is acceptable. The iter-149 escalation hook fires only
if BOTH sorries fail AND the substep 3 phrase doesn't narrow.

### Sub-target 1.B — Constants substep 3 (L294)

Declaration:
`AlgebraicGeometry.constants_integral_over_base_field` at L220–294.

**Current state** (post iter-147):
- Substeps (1)–(2) closed iter-146 (IsReduced + GeometricallyIrreducible
  ⇒ IsIntegral; IsIntegral + IsProper ⇒ `Γ(X, ⊤)` is a field
  finite over `k`).
- Substep 3 reduced via `rw [RingHom.range_eq_top]` to
  `Function.Surjective ⇑(appTop.hom)`.
- 7-step (a)–(g) closure chain documented in-source.
- Residual `sorry` at L294 (chain exit).

**Iter-148 closure path** — path (b) SMART PROOF via geom-reduced
+ purely-inseparable:

The iter-147 7-step chain (and its blueprint reflection post
iter-148 writer) routes through step (e) flat base change of `Γ`
for proper schemes — a 250–500 LOC Mathlib gap. Path (b) bypasses
this entirely:

1. **Γ is a finite field extension of `k`.** This is already
   closed by substeps (1)–(2) iter-146 — `Γ(X, ⊤)` is a field
   (via `isField_of_universallyClosed`) and finite over `k` (via
   `finite_appTop_of_universallyClosed`).
2. **Smooth ⇒ Γ separable.** From `Smooth (X ↘ Spec k)`,
   `Γ(X, O_X)` is geometrically reduced as a `k`-algebra. Mathlib
   has `Algebra.IsGeometricallyReduced` (in
   `Mathlib.RingTheory.Nilpotent.GeometricallyReduced` per the
   iter-148 mathlib-analogist's near-miss list). Combined with
   finite field extension ⇒ separable. The bridge "smooth scheme
   over field ⇒ Γ geom-reduced" may need a small wrapper if not
   directly in Mathlib.
3. **Geom-irr ⇒ Γ purely inseparable.** From
   `GeometricallyIrreducible (X ↘ Spec k)`, the finite field
   extension `Γ(X, O_X) / k` is purely inseparable. The intuition:
   geom-irr means `X_{\bar k}` is irreducible, which forces
   `Γ(X, O_X) ⊗_k \bar k` to have a single prime; for a finite
   field extension `K/k`, this means `K ⊗ \bar k` is a local
   ring with residue field `\bar k`, i.e. `K/k` is purely
   inseparable. Mathlib search candidates:
   `IntermediateField.isPurelyInseparable` /
   `Field.purelyInseparable_iff_*` / similar.
4. **Separable ∧ purely inseparable ⇒ trivial.** Mathlib has this
   (search for `IsSeparable` + `IsPurelyInseparable` + `iff_trivial`
   or `eq_bot_iff` style lemmas).
5. **Trivial extension ⇒ surjectivity.** `Γ(X, O_X) = k` as a
   field extension ⇒ `algebraMap k Γ(X, O_X)` is bijective ⇒
   surjective. Close the goal.

**Estimate**: ~150–250 LOC.

**Fallback strategy if path (b)'s Mathlib bridge is unavailable**:
The path (b) gap, if present, is "Γ of smooth ⇒ Γ separable" or
"geom-irr ⇒ Γ purely inseparable". If neither bridge exists in
Mathlib in usable form:
- PARTIAL the sorry. Document which exact Mathlib lemma is
  missing in a structured `sorry` comment block at L294.
- Iter-149+ then commits to path (a) BUILD or path (c) DEFER.

**The iter-147 7-step chain stays in the in-source comment block**
as the alternative path (a) fallback. The iter-148 prover should
NOT delete it; the 7-step chain reflects path (a) and remains a
valid (if expensive) alternative.

### Order of attack (planner recommendation)

1. **Sub-target 1.A (KDM)** first. Mechanical char-0 work; should
   close within ~80–150 LOC; frees mental budget.
2. **Sub-target 1.B (constants)** second. Substantive but
   well-bounded via path (b). If the smart-proof bridge proves
   inaccessible, PARTIAL is acceptable.

The prover may re-order if dependencies suggest otherwise; both
sub-targets are signature-stable (no signature work needed iter-148).

### Per-task informal proof content

- Sub-target 1.A: `blueprint/src/chapters/RigidityKbar.tex`
  § `\lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero`,
  primary path (p2) section (post iter-148 writer).
- Sub-target 1.B: `blueprint/src/chapters/RigidityKbar.tex`
  § `\lem:constants_integral_over_base_field`, 7-step (a)–(g)
  chain (post iter-148 writer). Note that the chapter prose
  documents path (a) [BUILD via flat base change]; path (b)
  [SMART PROOF] is the planner's iter-148 commitment and lives
  in `STRATEGY.md` § "Routes" and in this objectives file. The
  prover should follow path (b) per this directive; the chapter
  prose is consultative for the underlying mathematics
  (specifically, the iter-147 7-step chain shows what NOT to do
  this iter — go around step (e) via smooth ⇒ separable + geom-irr
  ⇒ pi).
