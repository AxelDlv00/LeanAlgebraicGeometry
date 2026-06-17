# Blueprint Review Report

## Slug
iter123

## Iteration
123

## Top-level summaries

### Incomplete parts
- None observed in any chapter. Every chapter has at least skeleton-level
  prose plus statements; the named-deferred Mathlib gaps
  (`instIsMonoidal_W`, `SheafOfModules.pullback_tensorObj`,
  `SheafOfModules.pullback_oneIso`, `nonempty_jacobianWitness`,
  `Pic_representable`, `HasCechToHModuleIso`,
  `HasAffineCechAcyclicCover`) are honestly documented as named
  oracles, not silently missing.

### Proofs lacking detail
- None blocking iter-123. The iter-123 focal lemma
  `lem:appLE_isLocalization` (Differentials.tex §sec:bridge,
  L162–188) gives a five-step proof (Steps 0–4) with named Mathlib
  closure pieces; Steps 1–4 (Step 0 done iter-122) are each one
  paragraph with named Mathlib leverage and are prover-actionable.
  See "Per-chapter / Differentials.tex" for full HARD-GATE notes.
- Soft: `Picard_LineBundle.tex / thm:SheafOfModules_pullback_tensorObj`
  and `thm:SheafOfModules_pullback_oneIso` have proofs that gesture
  at "tensor–hom adjunction" and "structure-sheaf identity" without
  concrete strategy. Not blocking — these are named-deferred Mathlib
  gaps awaiting an upstream refresh, not prover targets.
- Soft: `Picard_Functor.tex / thm:Pic_representable` is the FGA
  representability theorem; the proof is a "see FGA Chapter 9"
  reference. Acceptable since this is the single explicit Phase-C
  gap, deferred under the Albanese-route exit policy and absorbed
  into `nonempty_jacobianWitness`.

### Lean difficulty quality
- All `\lean{...}` hints in chapters bearing on iter-123 prover work
  point at well-typed Lean names with concrete signatures.
- `Differentials.tex / \lean{AlgebraicGeometry.IsAffineOpen.appLE_isLocalization}`:
  verified to exist in the project (`Differentials.lean:282`); the
  namespace `IsAffineOpen` is correct (file uses
  `namespace AlgebraicGeometry.IsAffineOpen` at L70, closing at L306).
  Signature has the right `IsLocalization` shape against the colimit
  ring source and the appLE-unit submonoid. PASS.
- `Differentials.tex / \lean{AlgebraicGeometry.Scheme.smooth_locally_free_omega}`
  is the smoothness-criterion theorem (not the iter-123 focus); the
  proof body's Step 4.5 names
  `AlgebraicGeometry.Scheme.component_nontrivial` as the
  `Nontrivial B` discharge. This is identified as a project-side
  helper rather than a Mathlib name; the prover will need to
  confirm it exists (or supply it) at formalization time. Not
  iter-123-blocking but flag for the next iter that targets
  `smooth_locally_free_omega`.
- All Jacobian / AbelJacobi / Rigidity / Picard-arc hints checked
  against the Lean source layout: namespaces and protected names
  match the descriptors in `archon-protected.yaml` (verified via
  grep against `Jacobian.lean:176` for `nonempty_jacobianWitness`).

### Multi-route coverage
- Single primary route (Albanese / Picard-scheme machinery) with
  Jacobian.tex explicitly enumerating three sub-routes for the
  existence theorem `nonempty_jacobianWitness`:
  - **Route A (Picard scheme via FGA)** — PASS. Sub-steps A.1–A.4
    in Jacobian.tex L255–284 each named with its Mathlib gap.
  - **Route B (Symmetric powers + Stein factorisation)** — PASS.
    Sub-steps B.1–B.3 in L286–311 with the three independent Mathlib
    gaps clearly catalogued.
  - **Route C (genus-0 sub-case, base-change + Galois descent)** —
    PASS. Sub-steps C.1–C.3 with the iter-121 expansion of C.2 into
    the seven-step C.2.a–C.2.g argument (L319–369). The two-step
    base-change-and-descent design avoids the Brauer–Severi
    counterexample obstruction; the descent step C.2.f is identified
    as a contribution candidate. AbelJacobi.tex correctly
    cross-references this expansion at line 82.

## Per-chapter

### blueprint/src/chapters/AbelJacobi.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Three protected declarations (`def:ofCurve`,
    `lem:comp_ofCurve`, `thm:exists_unique_ofCurve_comp`) each
    close by projection from the Albanese-witness machinery of
    Chapter `Jacobian.tex`. Clean.
  - Cross-references to Jacobian.tex's seven-step C.2 expansion
    (line 82) and Rigidity.tex (chap:Rigidity) are well-formed.
  - All `\uses{...}` links resolve to existing labels in this
    chapter or in `Jacobian.tex` / `Genus.tex` / `Rigidity.tex`.

### blueprint/src/chapters/Cohomology_MayerVietoris.tex
- **complete**: true
- **correct**: true
- **notes**:
  - The Mayer–Vietoris five-term sequence, exactness theorem,
    Čech-acyclicity carrier classes (`HasCechToHModuleIso`,
    `HasAffineCechAcyclicCover`), and `X_4`-corner whole-space
    bridges are all stated with `\lean{...}` hints and one-paragraph
    proofs that cite either Mathlib or upstream chapter results.
  - The two carrier classes ship as "currently unproduced" — this
    is the project's explicit Phase-A step-6 exit policy (parallel
    to the Phase-C `nonempty_jacobianWitness` exit). Documented
    honestly in §sec:mv_use_in_project ¶"Producer status".
  - All `\uses{...}` edges checked: every cited label exists
    in this chapter or in `Cohomology_StructureSheafModuleK.tex`.

### blueprint/src/chapters/Cohomology_SheafCompose.tex
- **complete**: true
- **correct**: true
- **notes**:
  - One-theorem chapter (`thm:HasSheafCompose_forget`). Proof is
    the standard "limit-preserving functors compose" argument; the
    statement is at instance shape, matching its Lean form
    `AlgebraicGeometry.Cohomology.instHasSheafCompose_forget_CommRing_AddCommGrp`.

### blueprint/src/chapters/Cohomology_StructureSheafAb.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Three building blocks: sheafification of Ab-valued sheaves,
    `Ext` on the same site, structure sheaf as Ab-sheaf. All three
    proofs are routine "infer from Mathlib + universe pinning".

### blueprint/src/chapters/Cohomology_StructureSheafModuleK.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Substantial chapter (655 lines) covering Phase-A step-5 in
    full: the k-module-valued structure sheaf, `HModule` /
    `HModule'` cohomology carriers, the `H^0`-algebraic-bridge
    linear equivalences, the Čech infrastructure, the
    `IsAffineHModuleVanishing` / `IsAffineHModuleHomFinite` /
    `IsHModuleHomFinite` carrier classes, Stein finiteness of
    global sections, and the producer instance
    `inst:Scheme_instIsHModuleHomFinite_toModuleKSheaf`.
  - All declarations have `\lean{...}` hints and one-paragraph
    proofs citing concrete Mathlib infrastructure or upstream
    project lemmas.
  - The wholespace vs. affine-quantified Hom-finiteness distinction
    (corrective carrier in §sec:IsHModuleHomFinite_iter043) is
    correctly motivated by the proper-curve counterexample.

### blueprint/src/chapters/Differentials.tex
- **complete**: true
- **correct**: true
- **notes**:
  - **HARD GATE (iter-123 prover focal point) — PASS.**
  - `lem:appLE_isLocalization` (L154–188) is detailed enough for
    Steps 1–4 (Step 0 done in iter-122). Each step names its
    Mathlib closure piece:
      * Step 1 → `IsLocalization.lift`;
      * Step 2 → cocone universal property + basic-open refinement
        via `AlgebraicGeometry.IsAffineOpen.isLocalization_basicOpen`
        + quasi-compactness of `f V` + `PrimeSpectrum.isBasis_basic_opens`;
      * Step 3 → `IsLocalization.ringHom_ext` and the colimit
        `IsColimit.hom_ext`;
      * Step 4 → `IsLocalization.of_le` or
        `IsLocalization.isLocalization_of_algEquiv`.
    Step 2 is the longest paragraph (the only non-routine step);
    the basic-open-refinement design via the union submonoid
    `⟨g⟩ ⊆ M` is concrete enough to formalize.
  - **Namespace check — PASS.** `\lean{AlgebraicGeometry.IsAffineOpen.appLE_isLocalization}`
    matches the namespace `AlgebraicGeometry.IsAffineOpen` opened
    at `Differentials.lean:70` and closed at `:306`. The theorem
    declaration at L282 sits cleanly inside.
  - **`\uses{...}` links — one wrong-direction edge.** The lemma
    `lem:kaehler_localization_subsingleton` (L190–202, a thin
    re-export of `FormallyUnramified.subsingleton_kaehlerDifferential`
    for any `IsLocalization`) has `\uses{lem:appLE_isLocalization}`.
    This is wrong-direction: the subsingleton lemma is strictly
    more general and does not depend on the appLE-specific
    `IsLocalization` instantiation. It does NOT break the iter-123
    prover work (the broken edge points DOWNWARD from
    `subsingleton` to `appLE_isLocalization`, not the other way),
    and the labels exist, so this is a soon-fix issue, not a
    must-fix-this-iter. Recorded under Cross-chapter notes.
  - Bridge theorem `thm:relativeDifferentialsPresheaf_equiv_kaehler_appLE`
    (M1) has a clean M1.a–M1.e decomposition; M1.c, M1.d, M1.e
    each cite the right Mathlib pieces.
  - `thm:smooth_locally_free_omega` proof (forward smoothness
    criterion, NOT iter-123 focal point) has a clean 4.5-step
    decomposition. Step 4.5 names `AlgebraicGeometry.Scheme.component_nontrivial`
    as the `Nontrivial B` discharger — this is a project-side name
    not yet implemented (per `grep` of the source tree). Flag for
    the iter that targets `smooth_locally_free_omega`, but no
    iter-123 impact.
  - Section §sec:converse-out-of-scope correctly documents the
    Brauer–Severi-style counterexample (genus-0 case Spec k →
    Spec k[t]) and the missing `Subsingleton (Algebra.H1Cotangent A B)`
    hypothesis. M4 documentation clean.

### blueprint/src/chapters/Genus.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Compact (69 lines). Defines `def:genus` against the
    `k`-module-valued sheaf cohomology of Chapter
    `Cohomology_StructureSheafModuleK.tex`. The proof block
    documents the Lean implementation as a one-liner. The
    `noncomputable` user authorization is recorded.
  - Phase-A step-6 (Serre finiteness) is correctly identified as
    the deferred work, queued for the iteration that closes the
    Jacobian's `smoothOfRelativeDimension_genus`.

### blueprint/src/chapters/Jacobian.tex
- **complete**: true
- **correct**: true
- **notes**:
  - `thm:nonempty_jacobianWitness` (L239) carries the full
    multi-route gap analysis. Iter-121's 7-step rigidity expansion
    (C.2.a–C.2.g, L321–358) successfully replaced the prior
    one-sentence stub; iter-122's "line 376 + 388 base-change
    framing" landed and is consistent.
  - The Mathlib-infrastructure summary (α/β/γ at L373–376)
    matches the three routes' gap lists. Clean for any future M2.a
    prover lane.
  - Cross-references to `Rigidity.tex / thm:GrpObj_eq_of_eqOnOpen`
    (used in C.2.b) and to `AbelJacobi.tex / thm:exists_unique_ofCurve_comp`
    (downstream consumer) check out.
  - Note (informational): C.2.b argues the rigidity lemma's
    "group-object-on-source" hypothesis can be inlined for
    `P^1_kbar` since the source is irreducible/reduced/separated
    even without a group structure. This is a soft promise — if a
    future M2.a prover lane targets this, the "thin variant" or
    inlining will need to be explicitly produced. Not blocking.

### blueprint/src/chapters/Modules_Monoidal.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Phase-C step-C0 chapter. Five project-side instances enumerated
    in §Formalization status with their current Lean closure
    status. `instIsMonoidal_W` is documented as load-bearing
    post-C1 via Remark `rem:W_IsMonoidal_load_bearing` (the honest
    disclosure paragraph).
  - All `\uses{...}` edges and Lean hints check out against the
    actual `Modules/Monoidal.lean` layout.

### blueprint/src/chapters/Picard_Functor.tex
- **complete**: true
- **correct**: true
- **notes**:
  - C2 sub-step status updated for post-iter-109 reality:
    `Pic.pullback` hand-construction closed, gap consolidated to
    the pair `(thm:SheafOfModules_pullback_tensorObj,
    thm:SheafOfModules_pullback_oneIso)` plus `instIsMonoidal_W`.
  - `thm:Pic_representable` ships as deferred FGA-level Theorem
    under the Albanese-route exit policy. Honest.

### blueprint/src/chapters/Picard_FunctorAb.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Universe-bump from `AddCommGrpCat.{u}` to `AddCommGrpCat.{u+1}`
    correctly threaded for the étale-sheafification subsection
    (Definition `def:PicardFunctorAb_etaleSheafified`).
  - All declarations have `\lean{...}` hints; no broken `\uses{...}`.

### blueprint/src/chapters/Picard_LineBundle.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Post-C1 status note correctly states `LineBundle X :=
    (Skeleton X.Modules)ˣ`. The load-bearing disclosure for
    `instIsMonoidal_W` is cleanly cross-referenced to
    `Modules_Monoidal.tex`.
  - The pair (`thm:SheafOfModules_pullback_tensorObj`,
    `thm:SheafOfModules_pullback_oneIso`) of named-deferred Mathlib
    gaps is consistently documented with the matching iter-109
    framing (one Mathlib gap, two sibling iso-witnesses).
  - Pull-back functoriality (`thm:Scheme_Pic_pullback_id`,
    `thm:Scheme_Pic_pullback_comp`) declared closed using
    `Scheme.Modules.pullbackId` / `pullbackComp` + skeleton-of-iso
    projection. Consistent with `\leanok` on those theorems.

### blueprint/src/chapters/Rigidity.tex
- **complete**: true
- **correct**: true
- **notes**:
  - Self-contained Mumford §4 rigidity statement
    `thm:GrpObj_eq_of_eqOnOpen`. Proof sketch lists every Mathlib
    ingredient. Cleanly cross-referenced by `Jacobian.tex § C.2.b`
    as the reduction target.

## Cross-chapter notes

- **Wrong-direction `\uses{}` edge in Differentials.tex**:
  `lem:kaehler_localization_subsingleton` (L190–202) carries
  `\uses{lem:appLE_isLocalization}`. The subsingleton lemma is a
  thin re-export of `FormallyUnramified.subsingleton_kaehlerDifferential`
  and applies to ANY localization `A → L` at any submonoid `M`; it
  is more general than the specific appLE-instantiation. The
  forward proof of `thm:relativeDifferentialsPresheaf_equiv_kaehler_appLE`
  CORRECTLY uses both `lem:appLE_isLocalization` and
  `lem:kaehler_localization_subsingleton` as parallel inputs (line
  128 has them as siblings under `\uses{...}`). The downward edge
  on the standalone subsingleton lemma should be REMOVED. This is a
  silent dependency-graph corruption but does NOT block the iter-123
  prover work, since the broken edge points away from the prover's
  target (`appLE_isLocalization`) rather than toward it.
  **Severity: soon.** Defer fix; the next blueprint-writer dispatch
  for Differentials.tex (when Steps 1–4 land and the chapter is
  refreshed) should drop the wrong-direction `\uses{...}` clause.

- **Project-side helper name not yet in source**: Differentials.tex
  Step 4.5 of `thm:smooth_locally_free_omega` references
  `AlgebraicGeometry.Scheme.component_nontrivial`. This name does
  not yet exist in the project tree
  (grep of `AlgebraicJacobian/`). It is a project-introduced
  helper that the future prover round on `smooth_locally_free_omega`
  will need to either author or relocate to a real Mathlib name
  (candidate: anything like
  `AlgebraicGeometry.Scheme.basicOpen_eq_top` / sections-on-nonempty-opens
  utilities). **Severity: soon.** Not iter-123-blocking because
  `smooth_locally_free_omega` is not in this iter's prover scope.

## Strategy-modifying findings (if any)

None. The strategy is internally consistent across all 13 chapters.
The single Phase-C foundational hypothesis `nonempty_jacobianWitness`
is honestly absorbed into a deferred existence theorem with three
documented routes, and the Phase-A step-6 finiteness layer is
exposed as the two carrier classes (`HasCechToHModuleIso`,
`HasAffineCechAcyclicCover`) with the producer-status disclosure.

## Severity summary

- **must-fix-this-iter** — NONE. No chapter in the audit has
  `complete: partial | false` or `correct: partial | false`; no
  multi-route is MISSING; no broken (non-existent-label) `\uses{}`
  edges anywhere; no Lean-difficulty-quality finding on an active
  prover route.
- **soon** —
  - Differentials.tex `lem:kaehler_localization_subsingleton`:
    drop the wrong-direction `\uses{lem:appLE_isLocalization}`.
    Recorded above; rolled into the next blueprint-writer pass
    for Differentials.tex.
  - Differentials.tex `thm:smooth_locally_free_omega` Step 4.5:
    confirm or rename the `AlgebraicGeometry.Scheme.component_nontrivial`
    reference before the future iter that targets that theorem.
- **informational** —
  - Jacobian.tex C.2.b "thin variant or inlining" of
    `thm:GrpObj_eq_of_eqOnOpen` is a soft promise to be materialised
    when M2.a is targeted; not an issue for iter-123.
  - Picard_LineBundle.tex / `thm:SheafOfModules_pullback_tensorObj`
    and `thm:SheafOfModules_pullback_oneIso`: proofs gesture at
    "tensor–hom adjunction" / "structure-sheaf identity". Since
    these are named-deferred Mathlib gaps under the Phase-C exit
    policy, no further detail is required project-side until a
    Mathlib refresh lands the `Functor.Monoidal` instance.
  - Cohomology_MayerVietoris.tex Producer-status paragraph on the
    two carrier classes is honest and well-cross-referenced; no
    action.

## Overall verdict
One sentence: iter-123 HARD GATE is CLEARED for
`AlgebraicJacobian/Differentials.lean → Differentials.tex` —
the M1.b proof sketch is detailed enough for Steps 1–4, the
namespace `AlgebraicGeometry.IsAffineOpen` is confirmed correct
against `Differentials.lean:282`, and no broken (non-existent
label) `\uses{...}` edges block the prover; one wrong-direction
`\uses` and one not-yet-implemented helper name are flagged as
**soon** for future passes but do not affect iter-123.
