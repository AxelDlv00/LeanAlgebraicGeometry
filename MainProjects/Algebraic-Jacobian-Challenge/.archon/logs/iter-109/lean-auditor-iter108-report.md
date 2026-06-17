# Lean Audit Report

## Slug
iter108

## Iteration
108

## Scope
- files audited: 15 (all .lean files under `AlgebraicJacobian/`)
- files skipped (per directive): 0

## Per-file checklist

### AlgebraicJacobian/AbelJacobi.lean
- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - Compact reduction of the four protected declarations through `jacobianWitness.isAlbaneseFor`; the iter-073 status block accurately describes the file's current shape. Clean.

### AlgebraicJacobian/Differentials.lean
- **outdated comments**: 2
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 1
- **notes**:
  - L27 `## Status (iteration 064 — scaffold)` is the stale status header flagged in iter-107 — still present; **carry-over unchanged**.
  - L29 follow-up `All main declarations have sorry bodies. Closure trajectory ~10 iterations` is also stale: the file has substantial closed content (`cotangentExactSeqAlpha`, `cotangentExactSeqBeta`, `cotangentExactSeq_structure.h_zero` + `h_epi`, `relativeDifferentialsPresheaf_obj_kaehler`, `universalDerivation`, `moduleKPresheafOfModules_*`). Only 5 substantive sorries remain (L122, L636 `h_exact`, L718, L735, L877). Iter-107 already flagged this header; no change.
  - 6 sorries total in file (counting L122 `relativeDifferentialsPresheaf_isSheaf`, L636 `h_exact`, L718 `smooth_iff_locally_free_omega`, L735 `cotangent_at_section`, L877 `serre_duality_genus`). Each has a structured docstring naming the obstruction; not orphan narrative.

### AlgebraicJacobian/Genus.lean
- **outdated comments**: 1
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - L14 `## Status (iteration 011 — genus closure scheduled)` is stale — the body at L65-68 is actually closed (one-liner against `Module.finrank k (HModule k (toModuleKSheaf C) 1)`). The header narrates a planned closure that already happened, so the "scheduled" framing has rotted. Minor.
  - L39-61 carries a 22-line commented-out `OXAsAddCommGrpSheaf`/`H1OC` sketch from a prior Phase A iteration. The sketch is historical context, not a directive; could be trimmed but is not actively misleading. Minor.

### AlgebraicJacobian/Jacobian.lean
- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - L30-39 "Forbidden shortcut (sanity check)" block usefully documents why the witness-based definition is mandatory; this is *productive* commentary, not excuse-prose.
  - L179 `sorry` on `nonempty_jacobianWitness` is explicitly authorised by `STRATEGY.md` per the file docstring; it is the deferred existence that bundles the Phase-C content. Acceptable.

### AlgebraicJacobian/Rigidity.lean
- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - File is fully closed (`eq_of_eqOnOpen` is theorem-mode-closed by a 7-line proof, L91-114). The "Hypothesis correction (iter 003 prover)" block accurately documents why the original symmetric statement was strengthened. Clean.

### AlgebraicJacobian/Cohomology/BasicOpenCech.lean
- **outdated comments**: 1
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 1 (the iter-108 DEFERRED block at L1846-1855)
- **notes**:
  - **File-header docstring L17 is stale**: claims `basicOpenCover_isCechAcyclicCover_toModuleKSheaf` "currently carries two labelled substep sorries plus the iter-062 `h_a_fun` scaffolding". Actual sorry count inside that theorem is 5 (L1212 substep-a, L1536 `h_transport`, L1564 `h_a₀` for `s₀`, L1754 `g_R.map_smul'`, L1846 `h_loc_exact`). Not iter-107 carry-over — this header rot has accumulated through Steps b1/b2/c growth without a corresponding update.
  - **L1846 DEFERRED annotation (iter-108 new)**: cites `IsLocalizedModule.{Away,pi,prodMap}` and `instIsLocalizedModuleToLinearMapToAlgHomOfIsLocalizationAlgebraMapSubmonoid` as the Mathlib infrastructure that would close the sorry. Verification: `IsLocalizedModule.Away` exists verbatim (`Mathlib/Algebra/Module/LocalizedModule/Away.lean:18`). `IsLocalizedModule.pi` and `IsLocalizedModule.prodMap` do **not** exist as named declarations — Mathlib has the corresponding *instances* (`IsLocalizedModule S (.pi fun i ↦ ...)` and `IsLocalizedModule S (f.prodMap g)`) at `Mathlib/RingTheory/TensorProduct/IsBaseChangePi.lean:82,97`. The comment's `IsLocalizedModule.{...}` brace-notation reads like project-local shorthand for "the family of instances around `LinearMap.pi`/`LinearMap.prodMap`," which is honest but imprecise. `instIsLocalizedModuleToLinearMapToAlgHomOfIsLocalizationAlgebraMapSubmonoid` does **not** exist verbatim either; the closest is the unnamed instance at `Mathlib/Algebra/Module/LocalizedModule/IsLocalization.lean:49`. Aggregate: the annotation correctly identifies the conceptual Mathlib infrastructure but invents instance names; no recipient could `lean_local_search` these names successfully. Minor citation precision issue but not a contradiction.
  - **Inline scaffolding L1786-L1834 (iter-108 preserved)**: verified self-consistent against directive's "flag only if has un-noted contradictions, references to non-existent Mathlib names, or contradicts its own annotation comments" criterion.
    - `h_V_le_U` (L1786-1789) — closed inline via `Pi.π.le.trans basicOpen_le`.
    - `h_slice_eq` (L1791-1795) — uses `Scheme.basicOpen_res` ✓ (exists at `Mathlib/AlgebraicGeometry/Scheme.lean`).
    - `h_pi_eq_inf'` (L1799-1812) — closed inline.
    - `h_V_affine` (L1814-1818) — uses `basicOpenCover_finset_inf'_isAffineOpen` ✓ (project-local at L261).
    - `h_isLoc` (L1822-1834) — uses `IsAffineOpen.isLocalization_of_eq_basicOpen` ✓.
    - All five `have` blocks land cleanly type-correct; the scaffolding consumes the iter-057 + iter-058 project helpers as advertised. No contradictions with the L1851-1853 comment "preserved as inert infrastructure."
  - **PAUSED scaffold L1064-L1119 (iter-105/107 carry)**: per directive, "flag only if visibly drifted from prior iters". The L1108/1118-1120 area now hosts the iter-107 staged `h_iter104 := cechCofaceMap_summand_family_R_linear hU s₀ n hn i r' y'` followed by `sorry` — this matches iter-107's "option 3 PARTIAL" annotation at L1115-1117. **No visible drift**.
  - 5 other transient sorries in `basicOpenCover_isCechAcyclicCover_toModuleKSheaf` and 1 in `cechCofaceMap_pi_smul`, plus 1 in `g_R.map_smul'`. All are documented per the file's existing decomposition narrative.
  - L1083-L1090 carries an "Iter-102 PLAN NOTE" inside `cechCofaceMap_pi_smul`'s body warning future provers about a whnf-timeout pitfall with `alternating_zsmul_pi_smul_aux_sum_comp`. Pragma-style guidance; useful, not stale.

### AlgebraicJacobian/Cohomology/MayerVietorisCore.lean
- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - File is sorry-free. The `Abelian.Ext.chgUniv_add`/`chgUniv_smul`/`chgUnivLinearEquiv` gap-fill (L62-112) is honest and labelled. The iter-016 → iter-026 chain of MV LES helpers is densely commented but every comment describes structure or motivation, not deferral. Clean.

### AlgebraicJacobian/Cohomology/MayerVietorisCover.lean
- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - File is sorry-free. The carrier-class predicate pattern (`HasCechToHModuleIso`, `HasAffineCechAcyclicCover`) at L492-684 is consistent with documented iter-050/053 design. Clean.

### AlgebraicJacobian/Cohomology/SheafCompose.lean
- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - 50-line file, 1 instance, honestly closed. Clean.

### AlgebraicJacobian/Cohomology/StructureSheafAb.lean
- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - 64-line file, three closed declarations. Clean.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean
- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - File is sorry-free. Includes the closed Stein/global-sections finiteness ladder (L605-777, `instIsHModuleHomFinite_toModuleKSheaf`). Every iter-N comment names a concrete role; none are orphans. Clean.

### AlgebraicJacobian/Modules/Monoidal.lean
- **outdated comments**: 1
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 1
- **notes**:
  - L18 `## Status (iteration 077 — refactor-subagent scaffold)` is stale relative to the iter-079/-080 inline analysis at L119-165. Minor.
  - **L100-165 (instIsMonoidal_W docstring)**: extended excuse-prose documenting *why* the body at L173 is `sorry`. The body is off-limits per directive (`refactor` denylist). **Carry-over unchanged from iter-107.** Per the auditor rule, a `sorry` on a load-bearing instance with multi-iteration excuse documentation is `must-fix-this-iter` even when "off-limits"; reported under must-fix below as a carry-over reminder.
  - L161-164 of the docstring asserts "this sorry does NOT block downstream consumers"; this remains a project-internal claim — no compile-time check distinguishes "blocks" from "doesn't block" since `sorry` ⇒ proof-by-falsity. Worth flagging as a soft-information leak (the project relies on the dispatcher's `representable` deferral to keep this contained).

### AlgebraicJacobian/Picard/Functor.lean
- **outdated comments**: 1
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 1
- **notes**:
  - L18 `## Status (iteration 005 — first prover round)` — stale iteration label.
  - **L29-36 "Forward-compatibility note (`LineBundle` approximation)" + L181-184 docstring on `PicardFunctor.representable`** — extended excuse-prose: "PicardFunctor.representable is intentionally left as `sorry`" / "do not attempt to fill it in iter-005". Body at L190 is `sorry`. **Off-limits per directive; carry-over unchanged from iter-107.**

### AlgebraicJacobian/Picard/FunctorAb.lean
- **outdated comments**: 0
- **suspect definitions**: 0
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 0
- **notes**:
  - File is sorry-free. Iter-004 status block at L20-29 and iter-008 block at L31-40 both accurately describe closed/in-place state. Clean.

### AlgebraicJacobian/Picard/LineBundle.lean
- **outdated comments**: 0
- **suspect definitions**: 1
- **dead-end proofs**: 0
- **bad practices**: 0
- **excuse-comments**: 1
- **notes**:
  - **L85-86 `def LineBundle (X : Scheme.{u}) : Type u := CommRing.Pic (X.presheaf.obj (op (⊤ : X.Opens)))`** — the weakened-wrong definition. The docstring at L17-60 + L71-84 explicitly labels it a *first-approximation / stand-in*, acknowledging that for non-affine schemes it is a "strict subgroup of the true Picard group". The whole module-level docstring is an extended excuse-comment on a load-bearing definition. **Carry-over unchanged from iter-107.**
  - `import Mathlib` (L6) is a wide import; same pattern in `Modules/Monoidal.lean:6` and `Genus.lean:6`. Project convention, but worth a one-liner reminder — narrow imports would catch breakage faster.

## Must-fix-this-iter

Apply verbatim.

- `AlgebraicJacobian/Picard/LineBundle.lean:85` — `def LineBundle X := CommRing.Pic (X.presheaf.obj (op ⊤))` is a "stand-in" for the real concept (invertible quasi-coherent `O_X`-module). Why must-fix: weakened-wrong definition on a load-bearing public name; the entire `Picard/`, `Jacobian.lean`, and `AbelJacobi.lean` chain consumes it. **Carry-over unchanged from iter-107.** Until `Modules.tensorObj` + `Modules.MonoidalCategory` (iter-079 closed in `Modules/Monoidal.lean`) is used to refine this definition, every downstream theorem about `Pic(X)` is implicitly a theorem about `CommRing.Pic Γ(X, ⊤)` instead.
- `AlgebraicJacobian/Picard/Functor.lean:190` — `PicardFunctor.representable := sorry` (off-limits per directive). Why must-fix: a `sorry` on a *theorem* that four `Jacobian.lean` sorries are documented to reduce to (per `Jacobian.lean` plan-narrative). **Carry-over unchanged from iter-107.** Defer rationale (don't fill on top of the wrong `LineBundle`) is mathematically defensible, but the resolution path remains: fix `LineBundle` first, then close.
- `AlgebraicJacobian/Modules/Monoidal.lean:173` — `instIsMonoidal_W := … sorry` (off-limits per directive). Why must-fix: excuse-prose documents a substantial Mathlib infrastructure gap (stalk-of-presheaf-tensor in the varying-ring setting); body is `sorry` on a typeclass instance, and instance-resolution diverges silently against `sorry`-by-falsity. **Carry-over unchanged from iter-107.**
- `AlgebraicJacobian/Differentials.lean:27` — `## Status (iteration 064 — scaffold)` is stale; the file has accumulated through iter-077/-081/-083/-086 with substantial closed content. Why must-fix: header asserts "All main declarations have `sorry` bodies. Closure trajectory ~10 iterations" which materially misleads future readers about the file's state (most main declarations have non-trivial closed bodies; only 5 sorries remain in 879 LOC). **Carry-over unchanged from iter-107.**

## Major

- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean:17` — file-header docstring claims `basicOpenCover_isCechAcyclicCover_toModuleKSheaf` "currently carries two labelled substep sorries plus the iter-062 `h_a_fun` scaffolding"; actual sorry count inside that theorem is 5 (L1212, L1536, L1564, L1754, L1846). New finding (not in iter-107).
- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean:1846` — DEFERRED comment cites instance/declaration names (`IsLocalizedModule.pi`, `IsLocalizedModule.prodMap`, `instIsLocalizedModuleToLinearMapToAlgHomOfIsLocalizationAlgebraMapSubmonoid`) that do not exist verbatim in Mathlib. The corresponding *anonymous* instances/concepts do exist at `Mathlib/RingTheory/TensorProduct/IsBaseChangePi.lean:82,97` and `Mathlib/Algebra/Module/LocalizedModule/IsLocalization.lean:49`. A future prover doing `lean_local_search` on these names will fail; the comment should cite the file paths and instance forms it actually means. Iter-108 new annotation.

## Minor

- `AlgebraicJacobian/Genus.lean:14` — `## Status (iteration 011 — genus closure scheduled)` is stale; the body is closed. Header narrates a planned-but-already-executed event.
- `AlgebraicJacobian/Genus.lean:39-61` — 22-line commented-out `OXAsAddCommGrpSheaf` / `H1OC` historical sketch from a previous Phase A iteration. Could be trimmed; not actively misleading.
- `AlgebraicJacobian/Modules/Monoidal.lean:18` — `## Status (iteration 077 — refactor-subagent scaffold)` is stale relative to iter-079/-080 work described in the body.
- `AlgebraicJacobian/Picard/Functor.lean:18` — `## Status (iteration 005 — first prover round)` is a stale iteration label (the file's iter-005 content is closed; only `representable` remains, which is intentionally deferred). Cosmetic.
- `AlgebraicJacobian/Picard/LineBundle.lean:6`, `AlgebraicJacobian/Modules/Monoidal.lean:6`, `AlgebraicJacobian/Genus.lean:6` — wide `import Mathlib`. Project convention; flagging for visibility only.

## Excuse-comments (always called out separately)

- `AlgebraicJacobian/Picard/LineBundle.lean:17-60` (file docstring + `def LineBundle` docstring): "we adopt a *first-approximation* definition", "genuine, non-vacuous stand-in", "strict subgroup of the true Picard group". Attached to load-bearing public `def LineBundle (X : Scheme.{u})`. **Severity: critical (carry-over unchanged from iter-107).**
- `AlgebraicJacobian/Picard/Functor.lean:29-36, 181-184`: "`PicardFunctor.representable` is intentionally left as `sorry`", "Intentionally deferred. This is FGA-level and not honestly closeable on the global-sections-approximate `LineBundle`. Do not attempt to fill it in iter-005". Attached to `theorem PicardFunctor.representable`. **Severity: critical (carry-over unchanged from iter-107; off-limits per directive).**
- `AlgebraicJacobian/Modules/Monoidal.lean:100-165, 157-159` (`instIsMonoidal_W` docstring): "Marked sorry until the upstream gap is filled", "Per user policy 2026-05-11, no project-local helper lemma may be introduced to bridge it — the closure must remain Mathlib-only". Attached to a typeclass `instance`. **Severity: critical (carry-over unchanged from iter-107; off-limits per directive).**
- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean:1846-1855` (iter-108 new): "DEFERRED (budget): provable from Mathlib's IsLocalizedModule.{Away,pi,prodMap} + … ; mechanization deferred at iter-108 (Archon canonical) due to letI-in-goal-type binder propagation friction (per-x algebra threading)". Attached to `h_loc_exact` inside `basicOpenCover_isCechAcyclicCover_toModuleKSheaf`. **Severity: major** — admission that an inline `have` is being deferred for non-mathematical (elaboration-budget) reasons; classified major rather than critical because the parent theorem is already in active development with multiple decomposed sorries, this is one more rather than a new excuse on a previously-clean object, and the cited reason ("budget" + "letI-in-goal-type binder propagation friction") is a concrete elaboration constraint, not a vague "will fix later". The annotation's specific obstruction (per-x algebra threading) is documented enough that the next prover round can diagnose.

## Severity summary

- **must-fix-this-iter**: 4 (all carry-over from iter-107).
- **major**: 2 (both new in iter-108: BasicOpenCech.lean:17 stale sorry-count header, BasicOpenCech.lean:1846 invented-name citations).
- **minor**: 5.
- **excuse-comments**: 4 (3 carry-over critical + 1 iter-108 new major).

Overall verdict: iter-108's new annotation block at `BasicOpenCech.lean:L1846-1855` is internally consistent with its preserved inline scaffolding (L1786-L1834 references real Mathlib + project helpers), but its Mathlib citations are imprecise (invents three instance names); the four iter-107 carry-over critical findings persist unchanged.
