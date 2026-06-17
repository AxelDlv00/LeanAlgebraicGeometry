# Session 60 (iter-060) — Review Summary

## Metadata
- Active sorry: **13 → 12** (FBC 4 parked · QuotScheme 4 · GrassmannianQuot 4 · SectionGradedRing **1→0** · FlatteningStratification 0).
- Targets: 2 prover lanes — SNAP (`SectionGradedRing.relTensorProj.naturality`), GR resource-fix (`GrassmannianQuot.bundleTransition_self`).
- Build: both touched files green. GrassmannianQuot cold `lake build` **succeeds** (8319 jobs, 22s, ~7GB) — the iters-058/059 OOM/exit137 ceiling is RESOLVED.
- Axioms (first-hand `#print axioms`): `bundleTransition_self`, `pullbackFreeIso_trans_symm_eqToIso`, `relTensorProj` all `{propext, Classical.choice, Quot.sound}`.
- dag: gaps=0, unmatched=16. blueprint-doctor: 0 findings. sync_leanok ran (iter 60, sha 8d6ce51, +13/-0, both chapters).

## Target 1 — SNAP `relTensorProj.naturality` (SectionGradedRing 1→0) — SOLVED
Closed the file's only remaining sorry; with `relTensorActL`/`relTensorActR` already landed (iter-058), all
three objectwise coequalizer-row natural transformations are now complete.

- **Attempt 1 (dead end, but diagnostic):** element-level `⊗`-induction at the `Ab` level —
  `apply AddCommGrpCat.hom_ext; ext z; induction z using TensorProduct.induction_on`. `zero` and `tmul`
  cases close by `rfl` (both composites send `m ⊗ₜ n ↦ (objRestrict P f m) ⊗ₜ[R(V)] (objRestrict Q f n)`
  definitionally — the feared `forget₂ CommRingCat RingCat` carrier identity does NOT bite under `rfl`).
  The `add` case FAILED: `simp only [map_add, ha, hb]` / `rw [map_add]` →
  `Did not find an occurrence of the pattern ?f (?x + ?y)` / `simp made no progress`. Root cause:
  the domain carrier `↥(AddCommGrpCat.of (P.obj U ⊗[ℤ] Q.obj U))` has the `AddCommGrpCat.of`-wrapped
  `AddCommGroup` instance, which does not unify with the bare-tensor `AddMonoidHomClass` `map_add` needs.
  **The real obstacle was additivity, NOT the carrier.**
- **Attempt 2 (RESOLVED):** prove the underlying `ℤ`-linear naturality square as `have key : … = …` of bare
  `ℤ`-linear maps (codomain restriction taken as `(AddCommGrpCat.Hom.hom (…).map f).toIntLinearMap`), via
  `TensorProduct.ext'` + `rfl` on the elementary tensor; then transport with
  `apply AddCommGrpCat.hom_ext; ext z; have hz := LinearMap.congr_fun key z; simpa only [...] using hz`
  (actL/actR simp set + `AddMonoidHom.coe_toIntLinearMap`). `TensorProduct.ext'` on the bare ℤ-tensor
  dissolves the additivity obstacle. Gotcha: a fresh `have` over `(P ⊗ Q)` re-resolves `⊗` to
  `TensorProduct` and fails synthesis — must write `MonoidalCategory.tensorObj (C := MonoidalPresheaf X) P Q`.
- Next downstream node: `relativeTensorCoequalizerIso` (step-2 promotion via `evaluationJointlyReflectsColimits`)
  — a NEW decl not yet in the file (plan agent must seed it; lvb-snap confirms the sketch is adequate).

## Target 2 — GR `bundleTransition_self` resource re-proof (GrassmannianQuot 4→4) — SOLVED
Sorry count unchanged (the 4 sorries were do-not-touch C2 + riders); the win is clearing the build ceiling.

- **Diagnosis:** the `set_option maxHeartbeats 1000000` was NOT an elaborator issue — the old `.hom`-cast
  chain *elaborates* fine at default heartbeats (LSP reaches `goals_after: []`), but a real `lake build`
  fails with `GrassmannianQuot.lean:599:8: (kernel) deterministic timeout`. At 1e6 the kernel passes but
  the term is large enough to drive cold build to ~227s / ~13GB+ → the OOM/exit137 of iters 058–059.
  **The LSP hides `(kernel) deterministic timeout`; only a real `lake build` (olean removed) exposes it.**
- **Attempt 1 (failed):** lower the override to 200000 and keep the old term → `(kernel) deterministic
  timeout`. Lesson: a passing kernel check uses the same memory regardless of heartbeat ceiling — the fix
  is the TERM, not the budget.
- **Attempt 2 (RESOLVED):** re-prove at the **iso level**.
  1. New generic helper `Scheme.Modules.pullbackFreeIso_trans_symm_eqToIso {φ ψ : T' ⟶ T} (h : φ = ψ) :
     pullbackFreeIso φ I ≪≫ (pullbackFreeIso ψ I).symm = eqToIso _`, proved `subst h; simp`. Because
     `φ ψ` are **variables**, the kernel never whnfs `chartIncl`/`chartTransition`.
  2. Matrix collapse `hB` in a *small* context (single overlap free sheaf, no pullback types):
     `apply Iso.ext; rw [matrixToFreeIso_hom, Iso.refl_hom, universalMinorInv_self, map_one, matrixEnd_one]`.
  3. Main goal: `simp only [bundleTransition]; erw [hB, Iso.refl_trans]; exact
     pullbackFreeIso_trans_symm_eqToIso hφ (Fin d)`. `erw [hB]` (not `rw`) bridges the standing
     Modules-diamond (hidden implicit base scheme, defeq-but-not-syntactic).
- **Verification:** cold `lake build` 227s→22s, peak ~7GB, axiom-clean; override removed. **OOM was
  proof-local — a file split is NOT needed**; the iter-061 C2 lane runs against the now-fast file.

## Subagent dispositions (full reports under `.archon/task_results/`, archived to `logs/iter-060/`)
- **lean-auditor iter060** (0 critical / 3 major / 1 minor): all code genuine — `bundleTransition_self` a
  real proof (no override), `relTensorProj.naturality` real (`key`+`rfl`), 4 GR sorries honest, no `opaque`
  decl (L716 is a comment word). All 3 majors = STALE `.lean` COMMENTS (review can't edit) → recs.
- **lvb-snap iter060** (0 must-fix / 1 major / 3 minor): file fully clean, `relTensorProj` faithful. Major =
  missing `\leanok` on `lem:relativeTensor_objectwise_coequalizer` (22-name multi-pin → sync gap) — **FIXED
  by manual override this phase** (all 22 pins axiom-clean; file 0 sorries/0 axioms). Minors → recs.
- **lvb-grquot iter060** (0 must-fix / 4 major / 5 minor): all 36 resolved pins faithful, 4 sorries honest.
  Majors = 3 coverage gaps blocking C2 (`matrixToFreeIso_mul`, `bundleTransition_cocycle_matrix` pinned but
  absent; helpers unmatched) + C2 sketch (`lem:gr_bundleCocycle_transport`) under-specified → recs §1.

## Key findings / patterns
- **Ab-level coequalizer-row naturality:** prove the bare `ℤ`-linear square via `TensorProduct.ext'`+`rfl`,
  THEN transport to `Ab` (`LinearMap.congr_fun`+`simpa`). Element-`⊗`-induction at the `Ab` level stalls on
  additivity (`AddCommGrpCat.of` carrier ≠ bare-tensor `AddMonoidHomClass`), not on the carrier.
- **Kernel-cost / OOM is invisible to the LSP.** Validate heavy proofs with a real `lake build` (remove the
  olean). Lowering `maxHeartbeats` never cuts memory — only a leaner term does. Keep concrete immersions
  opaque via a generic `subst`-proved iso-level helper (`φ,ψ` as variables) so the kernel never whnfs them.

## Blueprint markers updated (manual)
- `Picard_SectionGradedRing.tex`, `lem:relativeTensor_objectwise_coequalizer`: added `\leanok` to the
  **statement** block (L648) and **proof** block (L690). Justification: `sync_leanok` cannot evaluate the
  22-name multi-declaration `\lean{}` field, so it left the block unmarked; lvb-snap confirms all 22
  `RelativeTensorCoequalizer.*` pins exist and are axiom-clean, and first-hand checks confirm
  SectionGradedRing.lean has 0 active sorries / 0 axioms ⇒ every pin is sorry-free. Manual override warranted.

## Notes (low)
- lean-auditor L723–805 (minor): ~80 lines of superseded handoff comments in SectionGradedRing — cleanup
  for a future writer/refactor pass, not blocking.
