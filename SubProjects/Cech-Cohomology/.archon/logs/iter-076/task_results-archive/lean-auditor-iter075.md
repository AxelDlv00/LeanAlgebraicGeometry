# Lean Audit Report

## Slug
iter075

## Iteration
075

## Scope
- files audited: 1
- files skipped (per directive): 0 — directive restricted to one file

## Per-file checklist

### AlgebraicJacobian/Cohomology/CechSectionIdentificationLeg.lean

- **outdated comments**: 1 flagged
- **suspect definitions**: 0
- **dead-end proofs**: 1 flagged (orphaned scaffolding pair)
- **bad practices**: 3 flagged (duplicate helpers, exported-but-internal lemmas, high heartbeat limits)
- **excuse-comments**: 0
- **notes**:
  - **Line 15 — stale module docstring**: The module docstring reads "Carries the residual sorry `coreIso_comm_leg`." A grep for `sorry` in the file returns only this docstring line. `coreIso_comm_leg` (line 1544–1609) is fully proved with no `sorry`. The docstring actively misrepresents the proof status of the file.
  - **Lines 957–998 — orphaned scaffolding: `pushPullLegIso` + `pushPull_leg_coherence`**: `pushPullLegIso` (line 957, `private noncomputable def`) is referenced only inside `pushPull_leg_coherence`'s proof body (line 980, 993). `pushPull_leg_coherence` (line 974, `private lemma`) is **never called** anywhere — not in this file, not in any other file under `AlgebraicJacobian/`. A project-wide grep for both names returns only their definition and internal self-references. They appear to be dead-end scaffolding from an earlier approach to `pushPull_toRestrict_comm` that was abandoned when the latter switched to `rawPushPullMap_self`/`rawPushPullMap_self_gen` directly (line 1322–1323).
  - **Line 33 — `abHom_finsetSum_apply`: acknowledged duplicate of `CechAcyclic.ab_hom_finsetSum_apply`** (line 1552 of CechAcyclic.lean). Both are `private`, so no API conflict; the docstring explicitly labels it a "Local copy". Minor: if CechAcyclic is ever split or the private helper promoted, this copy will silently diverge.
  - **Line 246 — `overSigmaHomEq`: acknowledged duplicate of a `CechSectionIdentificationBase` private helper**. Same situation: both private, docstring labels it a local copy. Minor.
  - **Lines 1007, 1051, 1078, 1169, 1277 — five internal helpers exported without `private`**: `unit_pushforward_rFIP_inv`, `restrict_unit_comp`, `inner_beta_chain`, `pullbackComp_rFIP_compat`, and `pushPull_toRestrict_comm` are all declared as non-private `lemma`s. A project-wide grep shows none of them is referenced from any file other than CechSectionIdentificationLeg itself. They exist solely to support `pushPull_interLegHom_sections`. Exporting them unnecessarily enlarges the module's public API. Minor, but the pattern is consistent with similar helpers in Base being private.
  - **17 `set_option maxHeartbeats` overrides** (lines 109, 415, 622, 733, 903, 970, 1003, 1047, 1073, 1165, 1272, 1393, 1411, 1536, 1611, 1646, 1783). Two are particularly high: `set_option maxHeartbeats 6400000` at lines 1611 (`coreIso_comm_coface`) and 1646 (`coreIso_comm_sum`), and `set_option maxHeartbeats 3200000` at line 733 (`backboneIncl_proj`). In-file comments justify the high limits for a few declarations (whnf cost on nested fibre powers, definitional unfold of CechNerve), but most occurrences carry no explanation. Collectively this represents a performance smell: the file is slow to elaborate and may create fragile CI bottlenecks. The 6.4M limit is 64× the default and signals that the `coreIso_comm_coface`/`coreIso_comm_sum` proofs may benefit from profiling.
  - **`pls_eq` (line 1398)** — `private lemma` proved by `:= rfl` with a 1.6M heartbeat annotation. The statement equates `(pushPull_leg_sections 𝒰 F σ V).hom` with a spelled-out expression. `:= rfl` is sound here; the heartbeat annotation reflects that Lean's kernel must elaborate the RHS to confirm definitional equality, which is expensive. Not a soundness concern.
  - **`thin_resid5` (line 1378) and `map_op_eqToHom_swap` (line 1526)** — both use `subst` followed by `Subsingleton.elim` on `Opens.Hom` terms. This is the standard thin-category idiom (any two morphisms between the same opens are provably equal). Fully sound; no kernel-trap risk.
  - **No `sorry`s, no axioms, no `Classical.choice _` without authorization** anywhere in the file. The chain `unit_pushforward_rFIP_inv` → `restrict_unit_comp` → `inner_beta_chain` → `pullbackComp_rFIP_compat` → `pushPull_toRestrict_comm` → `pushPull_interLegHom_sections` → `coreIso_comm_leg` → `coreIso_comm_coface` → `coreIso_comm_sum` → `coreIso_comm` is fully proved and correctly wired. `coreIso_comm` is consumed by `CechSectionIdentification.lean` (lines 61 and 156).

---

## Must-fix-this-iter

None. No `sorry`, no axioms on substantive claims, no weakened definitions, no excuse-comments, no parallel API duplication with Mathlib.

---

## Major

- `CechSectionIdentificationLeg.lean:15` — Module docstring states "Carries the residual sorry `coreIso_comm_leg`." A file-wide sorry-grep returns only this line. `coreIso_comm_leg` is proved without sorry at lines 1544–1609. The docstring actively misrepresents proof status; any reader or automated tool treating the file as incomplete would be misled.

- `CechSectionIdentificationLeg.lean:957–998` — `pushPullLegIso` (private noncomputable def, line 957) and `pushPull_leg_coherence` (private lemma, line 974) are orphaned dead-end scaffolding. `pushPull_leg_coherence` is unreferenced anywhere in the project; `pushPullLegIso` is referenced only within `pushPull_leg_coherence`. The 42 lines of code add confusion about which approach to `pushPull_toRestrict_comm` is canonical and may mislead future provers working on related material.

---

## Minor

- `CechSectionIdentificationLeg.lean:33` — `abHom_finsetSum_apply` duplicates `CechAcyclic.ab_hom_finsetSum_apply` (both private). Acknowledged in docstring. Low risk; both are in separate modules and changes to CechAcyclic would not be caught here.

- `CechSectionIdentificationLeg.lean:246` — `overSigmaHomEq` duplicates a `CechSectionIdentificationBase` private helper. Same situation.

- `CechSectionIdentificationLeg.lean:1007,1051,1078,1169,1277` — `unit_pushforward_rFIP_inv`, `restrict_unit_comp`, `inner_beta_chain`, `pullbackComp_rFIP_compat`, `pushPull_toRestrict_comm` are published as non-private but are only referenced within this file. Consider `private` to avoid polluting the module's public API and to signal that these are implementation details.

- `CechSectionIdentificationLeg.lean:1611,1646` — `set_option maxHeartbeats 6400000` on `coreIso_comm_coface` and `coreIso_comm_sum`. The 64× limit is a fragile ceiling. If the proofs elaborate slightly slower on a future Lean/Mathlib bump, these will start timing out. Consider profiling (`lean_profile_proof`) or restructuring the elementwise arguments to reduce elaboration cost.

---

## Excuse-comments (always called out separately)

None. The only sorry reference in the file is in the module docstring at line 15, which is stale (describes a past state, not an intentional declaration). It is classified **major** above as a stale docstring, not as an excuse-comment (an excuse-comment would accompany a live declaration; this accompanies prose describing the file's former state).

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 2
- **minor**: 5
- **excuse-comments**: 0

Overall verdict: The iter-075 proof merge is structurally clean and fully sorry-free; the two major issues are a stale module docstring claiming an unfilled sorry and an orphaned scaffolding pair (`pushPullLegIso` + `pushPull_leg_coherence`) that should be deleted.
