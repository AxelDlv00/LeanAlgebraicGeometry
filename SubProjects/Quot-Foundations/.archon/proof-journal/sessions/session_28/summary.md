# Session 28 (iter-028) — Review Summary

## Metadata
- **Iteration:** 028 — 3 parallel import-independent prover lanes (FBC / QUOT / GR), all returned.
- **Sorry deltas (per file):**
  - `FlatBaseChange.lean`: **5 → 4** (closed `base_change_mate_inner_value_eq`). Active sorries @1445, 1817, 1995, 2017.
  - `QuotScheme.lean`: **4 → 4** (unchanged — 4 protected stubs; +2 axiom-clean helpers added, neither was a fill-the-sorry).
  - `GrassmannianCells.lean`: **0 → 0** (+4 axiom-clean declarations; objective was new decls, no sorry).
  - `FlatteningStratification.lean`: **1** (untouched — no prover; GF-geo @2264 gated on G1-core).
- **New axiom-clean declarations this iter: 6** (4 GR + 2 QUOT), all `{propext, Classical.choice, Quot.sound}`.
- **Build:** all three prover-edited modules `lake build` green; `sync_leanok` ran at sha `9d6d602`, iter 28, +22 `\leanok`, 0 removed, chapters touched = FBC / GrassmannianCells / QuotScheme. blueprint-doctor: **0 findings**.

## Per-target analysis

### FBC — `base_change_mate_inner_value_eq` @1608 — SOLVED (cascade, 5→4)
Replaced the ~50-line inline pre-subst reproof (which itself carried a `sorry` + a dead `set e/inclA/hfst`
scaffold and the WALLED `rw [Functor.map_comp]; simp only [...]` opening) with the one-liner
`exact base_change_mate_fstar_reindex ψ φ M`. `inner_value_eq` has the **same statement** as the
concrete-legs reindex, so the inline route was a redundant walled duplicate. Body is now inline-sorry-free;
the Seam-A content is consolidated into the single `_legs` crux. (Transitively still sorry-backed via
`fstar_reindex → fstar_reindex_legs → sorry@1445`.)

### FBC — `base_change_mate_fstar_reindex_legs` @1445 — BLOCKED (the `X.Modules` instance diamond)
The root Seam-2 telescoping. After the committed iter-026 `erw [...unitExpand]` unlock the goal has the
four-factor unit; step 1 is to collapse the surviving `Γ(pushforwardComp(g',Spec φ).hom)` factor. Three
application routes all fail:
- `rw [gammaMap_pushforwardComp_hom_eq_id]` → *"did not find an occurrence of the pattern …"*.
- `erw [gammaMap_pushforwardComp_hom_eq_id]` → **`whnf` heartbeat timeout** (1.6M, then 4M).
- Explicit term `hpfc := gammaMap_pushforwardComp_hom_eq_id _ _ _` (elaborates cheaply — unification only
  assigns the leg metavariables) followed by `rw [hpfc]` / `simp only [hpfc]` → *"did not find pattern"* /
  *"no progress"*.

**Root obstruction (named):** the collapse fact lives over the **composed** functor
`pushforward(LEG) ⋙ pushforward(Spec φ)` (the `.hom.app` domain), whereas the goal's matching factor —
produced by the `rw [Functor.map_comp]` split at step (ii) — carries the **nested-`obj`** form of the same
object. Defeq but **not syntactically equal** → `rw`/`simp` cannot abstract the motive; `erw`'s defeq search
times out. The same diamond recurs at each of the three atom cancellations and at `gstar_transpose`.
Left in place: `hpfc` (proves the fact is available + cheap) + a precise diamond-diagnosis comment, then
`sorry`; bumped `maxHeartbeats` to 4000000.

### FBC — `base_change_mate_gstar_transpose` @1817 — NOT ADVANCED (same diamond class, gated on `_legs`)
Considered assembling from the in-place `huce/hcounitL/hcounitR` scaffold + Seam A + Seam B, but: (1)
transitively gated on `_legs` (its Seam-A input `inner_value_eq` is sorry-backed via `_legs`); (2) the prior
iter's scaffold already documents the `ε_g` counit-app object differing syntactically from `W`'s body — the
same instance-diamond class; (3) isolating `ε_g` additionally needs the tilde-Γ counit to be an iso on a
specific pushforward object (a non-trivial QC fact). Left the existing scaffold + sorry as the right partial;
did not pile on another diamond-defeated `rw`.

### QUOT — `isLocalizedModule_basicOpen_of_presentation` @686 — SOLVED (axiom-clean)
`haveI : IsIso M.fromTildeΓ := isIso_fromTildeΓ_of_presentation M P` (Mathlib, `Tilde.lean:398`) then
`exact isLocalizedModule_restrict_of_isIso_fromTildeΓ M f` (existing file engine). The Route-F endpoint for
the **globally-presented** sub-case.

### QUOT — `map_units_restrict_basicOpen` @705 — SOLVED (axiom-clean)
`rintro ⟨x, n, rfl⟩; simpa using (tilde.isUnit_algebraMap_end_basicOpen M f).pow n`. Key non-obvious fact:
`tilde.isUnit_algebraMap_end_basicOpen` (`Tilde.lean:182`) proves the `End`-unit for an **arbitrary**
`M : (Spec R).Modules`, not just `tilde N`. The `map_units` field of G1-core is therefore **free**.
*Dead-end warning:* do NOT `infer_instance` the `Module Γ(O,Df) Γ(M,Df)` on a `let`-bound carrier — the
`modulesSpecToSheaf` carrier forgets scalars to `R` and the `let` hides the scalar tower; use the Mathlib
lemma directly (it `change`s through the tower internally).

### QUOT — `isLocalizedModule_basicOpen_of_isQuasicoherent` (full G1-core) — BLOCKED (the QCoh≃Mod gap)
**Key structural finding (changes the decomposition):** the file already carries (from iter-026, axiom-clean)
`isLocalizedModule_restrict_of_isIso_fromTildeΓ`, its reverse, and the `iff`. Therefore
**G1-core ≡ gap1 ≡ the single lemma** `isIso_fromTildeΓ_of_isQuasicoherent`. The Route-F "3-field
constructor" framing is **over-decomposed**: `surj`/`exists_of_eq` are already delivered for the iso case by
the existing engine; only the global tilde identification `IsIso M.fromTildeΓ` from local quasi-coherent data
is irreducible. Both the global-presentation shortcut and the stalk shortcut were investigated and ruled out
against Mathlib source (no `IsQuasicoherent → IsIso fromTildeΓ`, no `→ tilde.essImage`, no
global-generation-on-compact). The genuine remaining work is the multi-session Route-F port whose crux is
**Step 1**: a finite basic-open tilde cover from `QuasicoherentData` + presentation transport across
`D(g) ≅ Spec R_g` (the site-`over` ↔ scheme-pullback bridge).

### GR — `chartTransition'` (t'), `chartTransition'_fac` (t_fac) + 2 helpers — SOLVED (axiom-clean)
`t'` is a direct concrete composition; `t_fac` needed the documented **HasPullback-diamond recipe**: keep the
iso from one source (`(Iso.inv_comp_eq _).mp (awayPullbackIso_inv_fst _ _)`), fire the snd-leg with `erw`
(defeq-tolerant), and close the assoc-laden goal with `exact congrArg (_ ≫ ·) hXY` (associativity by defeq
inside `exact`, NOT available to `rw`/`simp`). Pure-ring step `hXY` collapses cleanly with `← Spec.map_comp`.
Supporting `awayMulCommEquiv_comp_algebraMap` + `chartTransition'_ringIdentity` (`IsLocalization.ringHom_ext`).
Needed `set_option maxHeartbeats 1600000` (with explaining comment). **progress-critic minimum bar
(t_id/t'/t_fac) met and exceeded.**

### GR — `cocycle` / `theGlueData` / `Grassmannian.scheme` — PARTIAL (categorical reduction solved)
The categorical reduction is documented in a HANDOFF block:
`simp only [chartTransition', Category.assoc, Iso.inv_hom_id_assoc]` cancels both internal `apXY.inv ≫ apXY.hom`
pairs (both from the def → matched instances → `simp` fires), reducing `cocycle` to
`apᴵᴶ.hom ≫ (six Spec.map of cocycleΘ/swap) ≫ apᴵᴶ.inv = 𝟙`. Residual: strip the conjugating iso + collapse
the six `Spec.map`s to the **ring identity** `Φ = RingHom.id (Localization.Away (P^I_J·P^I_K))` — a rotated
analogue of `cocycleCondition`, ~30–50 LOC ring-level via `IsLocalization.ringHom_ext` → chart generators →
the matrix cocycle (reuse `cocycle_imageMatrix_eq`). `theGlueData`/`scheme` are gated on `cocycle`.

## Key findings / patterns
- **The `X.Modules` / `HasPullback` instance diamond is the cross-lane blocker.** It defeats `rw`/`simp`/`erw`
  on heavy concrete objects (`MvPolynomial …ℤ` localisations; `Γ∘(Spec φ)_*` composites). The two known
  escapes: (a) keep iso `.hom`/`.inv` from **one** source so instances match, then `simp` fires (GR cocycle
  internal pairs); (b) `erw` + `exact congrArg`/`Iso.inv_comp_eq` (defeq inside `exact`) (GR `t_fac`). Neither
  fully resolves the FBC `_legs` factor-rewrite — that needs term-mode congruence carried through the whole
  composite (the mathlib-analogist consult the planner's tripwire names).
- **G1-core collapsed to a single lemma.** `isIso_fromTildeΓ_of_isQuasicoherent` is the whole remaining
  content; the 3-field decomposition is over-stated.
- **`map_units` is free** via `tilde.isUnit_algebraMap_end_basicOpen` (any `M`, not just `tilde N`).

## Blueprint markers updated (manual)
- **None.** No new declaration is a pure Mathlib re-export (all 6 new decls are Archon proofs that *use*
  Mathlib lemmas but discharge their own obligation → no `\mathlibok`). The plan agent already added the
  `\mathlibok` anchors for the Mathlib *dependencies* this iter, and `sync_leanok` handled `\leanok`. No
  `\lean{...}` rename was reported (prover decl names match the planner's hints; the planner already
  corrected `isIso_fromTildeΓ_of_presentation` — no `Modules.`). No stale `\notready` to strip.

## Notes (LOW)
- lean-auditor flagged a dead `have hpfc` (FBC @1431) before `sorry@1445` (unused local → possible lint
  warning). Cosmetic; the accompanying comment is accurate.
- blueprint-doctor: clean (no orphan chapters, no broken `\ref`/`\uses`, no `axiom`s).
- 6 unmatched `lean_aux` coverage-debt nodes (the 6 new helpers) — listed in `recommendations.md`.

See `recommendations.md` for next-iter actions and the 2 lean-auditor must-fix docstring corrections.
