# Mathlib Analogist Report

## Slug
serre-duality-iter110

## Iteration
110

## Question

Read-only consult: does Mathlib b80f227 have infrastructure that bridges
Serre duality to a `Module.rank` / `Module.finrank`-style equality, at a
level the project can consume to close
`AlgebraicGeometry.Scheme.serre_duality_genus`
(`AlgebraicJacobian/Differentials.lean:877`):

```lean
theorem serre_duality_genus {k : Type u} [Field k]
    (C : Over (Spec (CommRingCat.of k))) [IsIntegral C.left] [IsProper C.hom]
    (hsmooth : Smooth C.hom) :
    Module.rank k (HModule k (toModuleKSheaf C) 0) =
      Module.rank k
        (HModule k (moduleKSheafOfModules C (relativeDifferentials C.hom)) 0)
```

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| A — Mathlib has full Serre duality? | NEEDS_MATHLIB_GAP_FILL | critical |
| B — Mathlib has partial pieces (canonical/dualizing sheaf, trace map for proper morphisms, coherent cohomology of proper schemes)? | NEEDS_MATHLIB_GAP_FILL | critical |
| C — Project's `HModule` vs Mathlib's `Sheaf.H` | PROCEED | informational |

## Per-question answers

### Q1 — Serre duality at the abstract level

**Finding**: **NONE EXISTS** in Mathlib b80f227.

Evidence:
- `lean_local_search "SerreDuality"` → `[]` (zero hits).
- `lean_local_search "serre_duality"` → only the project's own
  `AlgebraicGeometry.Scheme.serre_duality_genus` and snapshot copies in
  `.archon/logs/iter-067/...`, `iter-069/...`, `iter-075/...`, `iter-078/...`,
  `iter-079/...`. No Mathlib hits.
- File-system `grep -rE "[Ss]erre[Dd]uality|[Ss]erre.*duality|dualising"
  .lake/packages/mathlib/Mathlib/AlgebraicGeometry` → **no files found**.
- File-system `grep -rE "[Ss]erre"` across all of Mathlib returns 33
  files, all unrelated:
  - `CategoryTheory/Abelian/SerreClass/{Basic,Bousfield,Localization,MorphismProperty}.lean` — Serre subcategories of abelian categories (a Bousfield-localisation device, not duality).
  - `Algebra/Lie/SerreConstruction.lean`, `Algebra/Lie/Basis.lean` — Serre's presentation of semisimple Lie algebras.
  - `RingTheory/Valuation/Discrete/Basic.lean`, `NumberTheory/Modular.lean`, etc. — incidental references in number-theory and valuation contexts.
- `lean_leansearch "Serre duality smooth proper variety"` → returns
  `CommRing.Pic.mk_dual`, smoothness elimination principles, and
  `Algebra.FormallySmooth.projective_kaehlerDifferential` — none about Serre duality.

**Conclusion**: there is no abstract Serre-duality theorem in Mathlib for
schemes, projective varieties, smooth proper schemes, curves, or any
related category. The project cannot collapse `serre_duality_genus` to a
Mathlib lemma plus a bridge.

### Q2 — Cohomology dimension equalities & partial pieces (canonical sheaf, dualizing complex, trace map)

**Finding**: **NO partial pieces** at the algebraic-geometry level.

Detailed per-piece evidence:
- **Dualizing sheaf / canonical sheaf**:
  - `lean_local_search "DualizingSheaf"`, `"dualizing"` → `[]`.
  - `grep -rE "canonical[Bb]undle|canonicalSheaf|canonical.*[Ss]heaf|relative[Dd]ualizing|RelativeDualizing"
    .lake/packages/mathlib/Mathlib` → six "canonical" hits in
    `AlgebraicGeometry`, all unrelated (the canonical morphism
    `X → Spec Γ(X, ⊤)`, the subcanonical Grothendieck topology, the
    canonical map from a localisation). **No "canonical bundle / canonical
    sheaf" object in the Serre-duality sense.**
- **Trace morphism for proper morphisms** (the heart of Serre duality):
  - `grep -rE "[Tt]race[Mm]orphism|trace_morphism|TraceMorphism"` → seven
    files, all algebraic: `RingTheory/Trace/Basic.lean`,
    `LinearAlgebra/Trace.lean`, `LinearAlgebra/Matrix/Trace.lean`,
    `FieldTheory/Finite/Trace.lean`, `Algebra/Lie/Weights/Chain.lean`,
    `Algebra/DirectSum/LinearMap.lean`, plus a `Tactic/FunProp/Core.lean`
    incidental. **No `f_*ω_X → ω_S` trace morphism for a proper morphism
    `f : X → S`.**
- **Coherent cohomology of proper schemes**:
  - `grep -rE "[Cc]ohomology" .lake/packages/mathlib/Mathlib/AlgebraicGeometry`
    → five files only: `Properties.lean`, `Sites/BigZariski.lean`,
    `Sites/ElladicCohomology.lean`, `Modules/Sheaf.lean`,
    `AffineTransitionLimit.lean`. The first four mention "cohomology"
    only in passing (e.g. `IsCohomological`-style booleans on Grothendieck
    topologies); only `ElladicCohomology.lean` actually defines a
    cohomology theory (ℓ-adic, on the *pro-étale* site, valued in
    `Type (u+1)`) — and this is the **only place in Mathlib's algebraic
    geometry that consumes `CategoryTheory.Sheaf.H`**. There is **no
    Zariski coherent cohomology infrastructure** for `O_X`-modules /
    `SheafOfModules` in Mathlib b80f227.
- **Cohomology dimension equalities**:
  - `lean_leansearch "rank cohomology equals rank cohomology dual sheaf"`
    surfaces only `Module.dual_rank_eq` (rank `V*` = rank `V` for
    finite-dimensional free `V`) and the Erdős-Kaplansky theorems —
    abstract linear algebra; no sheaf-theoretic dualities.
  - `lean_leansearch "cohomology projective space zero degree"` → returns
    `CategoryTheory.ProjectiveResolution.exact₀`, `groupCohomology.π_comp_H0Iso_hom_apply`,
    and other purely-categorical hits. **No `H^0(P^n, O) = k`, no
    `H^1(P^n, O(-2)) = k`, no projective-space cohomology at all.**
  - `grep -rE "RiemannRoch|riemann_roch|RiemannHurwitz|riemann_hurwitz"`
    → no files found.

**Conclusion**: the only "partial pieces" findable are (i) `Module.dual_rank_eq`
for finite-dim vector spaces (zero geometric content; sees neither sheaf
nor cohomology nor curves) and (ii) the project's own
`relativeDifferentials` (already consumed; no duality bridge attaches to
it). Composing existing Mathlib pieces is **not viable**; the project
would have to reconstruct the entire geometric setup from scratch.

### Q3 — Project's `HModule` interface vs Mathlib's `Sheaf.H`

**Finding**: the project's `HModule` is a **faithful Mathlib-aligned
specialisation**, not a parallel API. No friction; no refactor obligation.

Evidence:
- Mathlib's `CategoryTheory.Sheaf.H` at
  `Mathlib.CategoryTheory.Sites.SheafCohomology.Basic:57-60`:
  ```lean
  def H (n : ℕ) : Type w' :=
    Ext ((constantSheaf J AddCommGrpCat.{w}).obj (AddCommGrpCat.of (ULift ℤ))) F n
  deriving AddCommGroup
  ```
- Project's `HModule` at
  `AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean:248-253`:
  ```lean
  noncomputable abbrev HModule (k : Type u) [Field k] {C} [Category C]
      {J : GrothendieckTopology C} [HasSheafify J (ModuleCat.{u} k)]
      [HasExt (Sheaf J (ModuleCat.{u} k))]
      (F : Sheaf J (ModuleCat.{u} k)) (n : ℕ) : Type (u+1) :=
    Abelian.Ext ((constantSheaf J (ModuleCat.{u} k)).obj (ModuleCat.of k k)) F n
  ```

Three structural observations:
1. **The shapes are identical** modulo `AddCommGrpCat → ModuleCat k` and
   `(ULift ℤ) → k`. Both are `Abelian.Ext` from a constant-sheaf coefficient.
2. **The `ModuleCat k` specialisation is necessary** for the project's
   target rank-equality. `Module.rank k _` requires a `Module k` instance
   on the cohomology, which Mathlib's `Sheaf.H` (valued in `Type w'`
   carrying only `AddCommGroup`) cannot supply. The project's `HModule`
   gets `Module k` automatically via `Abelian.Ext.instModule` from the
   `Linear k`-enrichment of `Sheaf J (ModuleCat k)` (auto-inferable via
   `Sheaf.linear` from `HasSheafify J (ModuleCat k)`). Bridging via
   `forget₂ (ModuleCat k) AddCommGrpCat` to use `Sheaf.H` would *lose*
   the `Module k` and fail at `Module.rank k`.
3. **The `noncomputable abbrev` choice is essential** (not `def`) so
   instance synthesis sees through the wrapper to find `Module k` and
   `AddCommGroup` — exactly per the iter-009 design rationale documented
   in `StructureSheafModuleK.lean:283-286`. `def` would break
   `Module.rank` / `Module.finrank` typechecking.

**Conclusion**: `HModule` is the canonical Mathlib idiom *would-be*
upstreamed once Mathlib gets a `Linear R`-flavoured `Sheaf.H` (cf. the
existing `Linear R`-enrichment of `Abelian.Ext.linearEquiv₀` that the
project already consumes in `HModule_zero_linearEquiv` at
`StructureSheafModuleK.lean:266-273`). Until then, the project's
specialisation is correct and necessary. **No refactor obligation, no
parallel-API risk.**

### Q4 — Closure cost estimate per scenario

The directive's three scenarios collapse to **only (c)**:

- **(a) Mathlib has full Serre duality, collapse to a Mathlib lemma + the `HModule`/`Sheaf.H` bridge**: NOT APPLICABLE. Zero infrastructure exists. LOC estimate vacuous.
- **(b) Mathlib has partial pieces and project must compose**: NOT APPLICABLE. The only pieces findable (`Module.dual_rank_eq`; project's own `relativeDifferentials`) do not span the duality bridge. LOC estimate indistinguishable from (c).
- **(c) Mathlib has neither and project must redefine + prove from first principles**: the only realistic scenario.

**Cost breakdown for (c)**:
1. **Trace map for the structure morphism of a smooth proper curve**
   `Tr_{C/k} : H¹(C, Ω_{C/k}) → k` — heart of the construction; requires
   residue-based local description + global integral-over-curve identification.
   Hartshorne III.7 setup, III.7.14 for the curve case.
2. **Duality pairing** `H⁰(C, F) × H¹(C, ω_C ⊗ F^∨) → k` for coherent `F`,
   specialised at `F = O_C` and `F = Ω_{C/k}` for the project's needs.
3. **Perfect-pairing theorem** (non-degeneracy + finite-dimensionality on
   both sides). The finite-dimensionality is partially set up via the
   project's `IsHModuleHomFinite` / `IsAffineHModuleVanishing`
   (`StructureSheafModuleK.lean:418-487`) but only for `H⁰` of the
   structure sheaf; the `Ω_{C/k}` finiteness needs the cotangent sheaf
   side, which itself needs `relativeDifferentialsPresheaf_isSheaf`
   (`Differentials.lean:122`) + `smooth_iff_locally_free_omega` (L718).
4. **Bridge to the rank equality** via `Module.dual_rank_eq` and the
   pairing; one-shot application once (1)–(3) land.

**Total LOC estimate (c)**: **3,000–8,000 LOC**. Multi-dozen prover
iterations. Comparable in scope to the Hilbert / Quot scheme gap that
drives Phase C3's deferral (cf. `STRATEGY.md` L19 "5,000–10,000 LOC each",
L72 "Hartshorne-chapter-sized undertaking"). The project's ~10–20
prover-iteration / ~280–500 LOC remaining budget (`STRATEGY.md` L22)
**cannot absorb this**.

### Q5 — Verdict

**NEEDS_MATHLIB_GAP_FILL.** Mathlib b80f227 has insufficient infrastructure
for any of the three scenarios. Recommend named-deferred sorry per the
project's existing exit policies (`JacobianWitness` for C3;
`instIsMonoidal_W` for C0; `cotangentExactSeq_structure.h_exact` for B).

## Must-fix-this-iter

None. There are no ALIGN_WITH_MATHLIB verdicts on already-shipped code;
the project's `HModule` shape is correct (PROCEED), and the missing
infrastructure (Serre duality / dualizing sheaf / trace morphism) is
upstream-absent (NEEDS_MATHLIB_GAP_FILL).

## Major

None. There are no ALIGN_WITH_MATHLIB verdicts on proposed-stage work
either.

## Informational

- **Decision A (Serre duality at the abstract level): NEEDS_MATHLIB_GAP_FILL.**
  Mathlib has zero coverage. No alignment work for the project; the gap
  is upstream.
- **Decision B (partial pieces — canonical sheaf, trace map, coherent
  cohomology of proper schemes): NEEDS_MATHLIB_GAP_FILL.** Same upstream
  gap, broader.
- **Decision C (project's `HModule` interface): PROCEED.** Faithful
  Mathlib-aligned specialisation of `Sheaf.H` to `ModuleCat k`-valued
  sheaves; no parallel-API risk. The `noncomputable abbrev` form is
  load-bearing for the `Module k` rank-equality and is the right idiom
  for a future upstream `Linear R`-flavoured `Sheaf.H`.

## Recommendation summary (for the plan agent)

**Defer `serre_duality_genus` indefinitely as a named Mathlib-gap sorry,
joining the existing 6 named gaps in `STRATEGY.md` L24-30. Do not open a
Phase B prover lane on L877 in iter-111 or any subsequent autonomous-loop
iteration.**

Concrete plan-agent action items (the plan agent decides, not the
analogist):
- Append a 7th named-gap entry to `STRATEGY.md` L24-30:
  `7. serre_duality_genus (Differentials.lean L877) — Serre duality for
   smooth proper curves. Mathlib b80f227 lacks Serre duality, dualizing
   sheaf, canonical sheaf, trace morphism for proper morphisms, coherent
   cohomology of proper schemes, and Riemann-Roch. Closure requires
   ~3,000–8,000 LOC of first-principles construction; comparable in
   scope to the Hilbert/Quot gap driving Phase C3 deferral.`
- Add a row to the `Mathlib gaps in scope` table (`STRATEGY.md` L97-106):
  `Serre duality / dualizing sheaf / trace morphism for proper morphisms |
  B | Defer indefinitely. Single named sorry at L877 per
  mathlib-analogist-serre-duality-iter110 verdict.`
- Update End-state disclosure (`STRATEGY.md` L75-87): named-gap count
  6 → 7. Phase B closure becomes "L122, L718, L735 prover-viable in
  parallel; L877 deferred via named-gap exit policy."
- Add a `% NOTE:` annotation in `blueprint/src/chapters/Differentials.tex`
  at the `\begin{theorem}` block for `serre_duality_genus`: clarify that
  closure is structurally blocked by Mathlib's absence of Serre-duality
  infrastructure; the statement is correct and consumed downstream by
  `genus`-rank instances; the proof body remains `sorry` as a named
  Mathlib gap.
- Iter-111 prover lane scoping: `serre_duality_genus` (L877) stays out of
  scope. L122, L718, L735 remain prover-viable in parallel
  (per `STRATEGY.md` L124, already correctly scoped for L122 first).
- Clear the variance flag carried iter-107/108/109 on this basis: this
  route is **not** an L1846/L1120 "discover-then-accrete" anti-pattern
  risk because the closure is structurally infeasible, not
  tractably-but-frictionful. The honest move is the named-gap deferral
  now, not opening a prover lane in iter-111+.
- **No `HModule` refactor.** The project's cohomology interface is the
  right Mathlib-aligned shape; do NOT absorb effort into bridging it to
  `Sheaf.H` (which cannot carry the `Module k` rank-equality at all).

## Persistent file
- `analogies/serre-duality.md` — design-rationale captured for future iters.

Overall verdict: **NEEDS_MATHLIB_GAP_FILL on the duality content; PROCEED
on the `HModule` interface.** The project should ship `serre_duality_genus`
as a 7th named Mathlib-gap sorry, mirroring the precedents set by
`JacobianWitness`, `instIsMonoidal_W`, and `cotangentExactSeq.h_exact`.
