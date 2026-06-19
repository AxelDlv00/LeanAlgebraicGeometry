# Strategy

## Goal

Close the `sorry`-bearing nodes of the **Grassmannian-quotient representability** cone (the
Čech-independent / H⁰ leg of the parent's `thm:fga_pic_representability` cone; Nitsure §1/§5,
FGA Explained Ch. 5), then merge back into *Quot-Foundations*:

- **GR-quot core** — `def:grassmannian_scheme`, `thm:grassmannian_representable`,
  `lem:tautologicalQuotient_epi`: the rank-`d` Grassmannian as a scheme glued from affine
  charts via the `GL_d` cocycle, representing the rank-`d`-quotient functor. χ-free (the
  Hilbert condition is constant rank `d`).
- **SNAP-S0** (ACTIVE — iter-006, user-directed) — `def:sectionsCast`, `lem:sectionsCast_refl`,
  `lem:gradedMonoid_eq_of_cast`, `lem:sectionMul_coherent` (+ graded `GMul`/`GOne` assembly): the
  H⁰ section graded ring `Γ_*(X,L)` (Stacks 01CV). Foundations
  (`tensorPow`/`sectionsMul`/`tensorObjAssoc`/`tensorPowAdd`) already proved axiom-clean in-leg.
  iter-007 pivot: the residual coherence laws are inherited from a Mathlib-aligned
  `MonoidalCategory`/`SymmetricCategory X.Modules` (monoidal localization), diverging from the
  sibling `FBC-B_SNAP-chain` encoding (which is stuck at 9 sorries on the same hand-rolled wall).
- **χ-blocked** (DEFERRED here) — `def:quot_functor`, `def:hilbert_polynomial`: in the parent's
  287-node cone but χ-semantic (need higher cohomology this leg lacks) and **not in the GR-seed
  cone**. Sourced from the cohomology leg at merge; kept as `sorry` here.

**Disjointness invariant (load-bearing).** The three closable seeds (`grassmannian_scheme`,
`grassmannian_representable`, `tautologicalQuotient_epi`) transitively `\uses` NO sorry-bearing
SNAP-S0 or χ-blocked node — confirmed at source level (`GrassmannianQuot.lean`, which holds all
three seeds + their construction, references 0 of {`hilbertPolynomial`, `QuotFunctor`,
`sectionsMul`, `sectionGradedRing`, `sectionsCast`}). To be re-confirmed via `#print axioms` once
the 3 GR sorries are closed: the only `sorryAx` admitted must come from the deferred SNAP/χ nodes
that the seeds do NOT depend on, i.e. each closed seed is kernel-axiom-only. If this invariant
ever fails, the SNAP/χ deferral becomes a goal-blocking gap, not an accepted dependency.

End-state: zero project `sorry` in the closable GR-seed cone, zero project axioms, kernel-only
axioms on the closed seeds. Names/labels/paths are the parent's so finished work merges back
cleanly.

## Phases & estimations

| Phase | Status | Iters left | LOC | Key Mathlib needs | Risks |
|---|---|---|---|---|---|
| SNAP-S0 — section graded ring assoc legs | ACTIVE (live: ★ placement gating B4/B5, + B6/B7; +3 comm-gated future) | 1 (★ closes via head-pin → B4/B5 auto-clean + B6/B7 same lane; if head-pin AND uniform-synonym restatement BOTH fail → user escalation, no further non-user variants) | ~50–120 | inherited monoidal structure + bridges DONE; `tensorPowAdd_zero_right`/B1/B2/B3/B5-assembly/B4-reduction DONE; ★'s residual generic coherence PROVEN axiom-clean (iter-016); `MonoidalCategory.pentagon`; in-synonym `Localization.Monoidal.μ_natural_*(_assoc)`/`associator_naturality`; `DirectSum.GSemiring` assembly | LIVE = assoc chain only. iter-013 REDUCED B4 to the isolated ★ `tensorObjAssoc_eta_factor_sheaf` (closing ★ auto-cleans B4+B5). iter-015 comp-bridge `hc` ⇒ ★ prefix compiles; iter-016 PROVED ★'s residual as a generic `[MonoidalCategory M]` coherence (axiom-clean) — math DONE — but ★'s placement `exact` blew >4M heartbeats. **progress-critic iter-017 STUCK** (6→6 ×4); corrective = mathlib-analogist consult (DONE), which **re-diagnosed: the wall is HEAD-MISALIGNMENT, not term size** — the failing `exact` lets the generic's `M` default to native `X.Modules`-comp while the `hc`-normalized goal carries the `LocalizedMonoidal` head ⇒ no `isDefEq` short-circuit, full 1.2M-char diamond traversal. FIX = pin `M` to the synonym (1-line); fallback = restate ★ uniformly in LocalizedMonoidal-comp. Then B6 `tensorPowAdd_assoc` (canonical pentagon, diamond-free, COMMITTED), B7 `sectionsMul_mul_assoc`. comm = invertibility-gated FUTURE, no consumer. |
| χ-blocked nodes | DEFERRED | — | — | higher-cohomology engine (absent here) | `hilbert_polynomial`/`quot_functor` filled from cohomology leg at merge |

**Leg status: GR-seed cone DELIVERED (iter-001); SNAP-S0 residue ACTIVE (iter-006).** Per user
directive the SNAP graded-section residue (9 sorries in `SectionGradedRing.lean`) is now being
proved in-leg on its already-closed foundations. The χ-blocked nodes remain DEFERRED (need a
cohomology engine absent here; filled from the cohomology leg at merge).

## Completed

(Inherited from the parent, in kept files. `Iters` cells are parent-side; this leg did not re-run them.)

| Phase | Iters (done@ · used) | LOC | Files | Key results | Reusable techniques | Pitfalls |
|---|---|---|---|---|---|---|
| GR-cells/glue/sep/proper | parent · — | ~1310 | `GrassmannianCells.lean`, `GlueDescent.lean` | charts, cocycle, `Grassmannian.scheme`, `isSeparated`, `isProper`, keystone `isIso_glueRestrictionHom` (0-sorry) | `IsLocalization.Away.lift`; `ValuativeCriterion`; cocycle telescopes via rotMid; effective descent NOT stalks | `Matrix.det_updateColumn` absent; `Spec.map_comp` rw fails on Scheme-cat diamond |
| GR-quot inverse + represents | parent · — | ~900 | `GrassmannianQuot.lean` | `grPointOfRankQuotient` (Nitsure §5 inverse), `represents` (modulo 2 inverse-law helper sorries, this leg) | equivalence-transport; joint reflection across chart cover | value-ModuleCat diamond: never positional rw |
| SNAP-S2 Hilbert–Serre engine | parent · — | ~1470 | `QuotScheme.lean`, `GradedHilbertSerre.lean` | `IsRatHilb.ofDiffEq`; `gradedModule_hilbertSeries_rational` (00K1) | Route-2 ambient-subquotient pairs sidestep quotient gradings | bundled `IsInternal` over quotient carrier = hard `isDefEq` dead end |
| QUOT P1+gap1+gap2 | parent · — | ~990 | `QuotScheme.lean` | schematic/proper support; `isIso_fromTildeΓ`; `isLocalizedModule_basicOpen` | equivalence-transport beats `IsContinuous`; open-imm pullback-unit IS Final | general-U `_of_cover` unprovable (basic-open only) |
| SNAP-S0 tensor crux + chain | parent · — | ~600 | `SectionGradedRing.lean` | `isIso_sheafification_whiskerRight_unit`; `tensorObjAssoc`; `tensorPowAdd` (axiom-clean) | `W.whiskerRight`@`ModuleCat (ULift ℤ)` + coequalizer descent (NOT stalks) | instance synth flaky in long `≪≫` — pass `@asIso _ _ _ _ f h` |
| GR-quot / repr — tautological quotient + representability | 001 · 1 | ~0 (3 sorries closed in-place) | `GrassmannianQuot.lean` | effective descent for `SheafOfModules`; `Functor.RepresentableBy` | `tautologicalQuotient_epi` (joint reflection + `epi_comp'`), `presentedMatrix_rqPullback`, `grPointOfRankQuotient_rqPullback_tautological` → `represents` sorry-free + axiom-clean | the two "calc-`Trans` toolchain bug" FIXMEs were misdiagnosed diamond-`rfl` gaps — append explicit `rfl` / use `congrArg…|>.trans` not `rw` |

## Routes

**GR-quot route — COMPLETE (iter-001).** Glue `SheafOfModules` over `Scheme.GlueData` →
effective-descent iso `isIso_glueRestrictionHom` → Nitsure §5 inverse `grPointOfRankQuotient` →
`represents` → residue `tautologicalQuotient_epi`: all sorries closed; `Grassmannian.represents`
sorry-free + axiom-clean (`[propext, Classical.choice, Quot.sound]`, no `sorryAx`) ⇒ disjointness
invariant verified (seeds use 0 SNAP/χ sorry nodes). Faithful Lean image of Nitsure §5 cell-gluing
+ `GL_d` cocycle; inverse/representability is Archon-original (Nitsure leaves it as §5 exercise).

**SNAP-S0 route — ACTIVE (iter-006; approach pivoted iter-007).** Not in the GR-seed cone
(disjoint, cannot disturb the delivered seed). Cast machinery + graded `GMul`/`GOne` + left-unit
law CLOSED axiom-clean (iter-006, 9→3 sorries). **iter-010/011 re-anchor:** `sectionsMul_mul_comm` is
FALSE for general `L` (free tensor algebra) — re-signed `[IsInvertible L]` (Stacks 01CR); comm proof +
its `tensorBraiding_self_eq_id_of_isInvertible`/`tensorPowAdd_comm` deps are invertibility-gated FUTURE
work with NO consumer (`GCommSemiring` unbuilt), so OUT of active scope. **Live = the assoc chain only**
(∀L, TRUE): B1 `presheafAssociator_top_apply` DONE; B2→B7 remaining, blocked on the `⊗ₜ`/`forget₂`
instance diamond (FIX = morphism-level statements, proven on B1; blueprint rewritten iter-012). **iter-007
pivot (mathlib-analogist ALIGN_WITH_MATHLIB, `analogies/tensorobjassoc.md`):** the residual coherence laws
are NOT hand-proved over the hand-rolled (obfuscated double-braiding) `tensorObjAssoc`; instead BUILD the full
`MonoidalCategory`/`SymmetricCategory X.Modules` via Mathlib monoidal localization —
`(J.W.inverseImage (toPresheaf R₀)).IsMonoidal` (whiskerRight = `ztensor_whisker_localIso` DONE;
whiskerLeft by braiding-conjugation, presheaves symmetric) + `LocalizedMonoidal` — so
assoc/pentagon/triangle/hexagon are INHERITED. Stalkwise routes DEAD. Merge-dedup with
`FBC-B_SNAP-chain` is moot (sibling stuck at 9 sorries on the same dead-end; standing directive
sanctions refactoring out of dead-ends).

**χ-blocked route — none here.** `quot_functor`/`hilbert_polynomial` need the χ
(Euler-characteristic) engine; this i=0 leg does not build it. They remain `sorry` and are
filled from the cohomology leg at merge.

## Open strategic questions

- **Q3 RESOLVED (iter 001).** The goal-delivering seed is `thm:grassmannian_universal_property`
  (`\lean{Grassmannian.represents}` in `Picard_GrassmannianQuot.tex`): a fresh scoped blueprint
  review confirmed it states the full representability (bijection `Hom(T,Gr) ≅ Grass(r,d)(T)`
  natural in `T`, i.e. `RepresentableBy` of the rank-`d`-quotient functor), and `represents` is
  proof-complete in Lean once the 3 GR sorries close. The weak `Scheme.Grassmannian.representable`
  skeleton (`thm:grassmannian_representable`, `Picard_QuotScheme.tex`, already `\leanok`) is a
  SEPARATE under-delivering pin (omits smoothness/properness/rel-dim/Plücker) that the closable
  cone does NOT rely on for goal delivery — kept as tracked debt, not a seed. Closing the 3 GR
  sorries → `represents` proven = goal theorem.
- **χ encoding consistency.** The blueprint `def:hilbert_polynomial` ENCODING comment claims an
  H⁰ encoding that contradicts the χ Lean decl. The Lean source governs; flag for the parent to
  reconcile the comment, but do NOT change the Lean to H⁰ in this leg.

## Mathlib gaps & new material

- GR-quot: effective descent for `SheafOfModules` over `Scheme.GlueData` (project-built).
- SNAP-S0: `(J.W.inverseImage (toPresheaf R₀)).IsMonoidal` ⇒ `MonoidalCategory`/`SymmetricCategory X.Modules` via Mathlib `LocalizedMonoidal` (iter-007); H⁰ section graded ring `Γ_*(X,L)`.
- `Grassmannian` (rank-`d` locally-free quotients) + representability as `IsRepresentable`.
