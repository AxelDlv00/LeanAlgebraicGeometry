# Session 254 (iter-254) — review summary

## Metadata
- **Iteration:** 254. Two prover lanes, both `opus`, mode `prove`.
- **Sorry count (declaration-level):**
  - `Picard/TensorObjSubstrate.lean`: **3 → 2** (STEP A `sheafifyTensorUnitIso_hom_natural` eliminated).
  - `Picard/TensorObjSubstrate/DualInverse.lean`: **2 → 2** (internal sorries inside `homOfLocalCompat`: 2 → 1).
- **Build:** GREEN, verified first-hand (`lake build AlgebraicJacobian.Picard.TensorObjSubstrate.DualInverse` → 8322 jobs, exit 0; full `AlgebraicJacobian` → 8367 jobs).
- **Targets attempted:** `sheafifyTensorUnitIso_hom_natural` (SOLVED), `pullbackTensorMap_natural` (PARTIAL), `homOfLocalCompat` (PARTIAL), `dual_restrict_iso` (not entered).

## Headline
The **"4th consecutive M=2 iter; the TS-cmp lane finally ELIMINATES the 5-iter STEP-A whisker wall
axiom-clean, and the TS-inv lane reduces `homOfLocalCompat` to ONE isolated ring-bridge — but neither
lane closes its assigned canonical target (D1′ / a fully-closed `homOfLocalCompat`)"** iter. Genuine
forward motion on both fronts; canonical critical-path counter still FLAT (D2′ was the iter-250 win).

## Lane TS-cmp (`Picard/TensorObjSubstrate.lean`, D1′)

### `sheafifyTensorUnitIso_hom_natural` — SOLVED axiom-clean (the 5-iter STEP-A wall)
Verified first-hand: `#print axioms` = `{propext, Classical.choice, Quot.sound}` — no `sorryAx`.

This is the lemma whose iter-253 *armed reversing signal fired NEGATIVE across 3 approaches*
(element-descent / whisker-calculus `whnf`-timeout / uniform-instance-helper synth-fail). The iter-254
planner dispatched a cross-domain analogist (tscmp254) that prescribed a δ/μ single-sided-naturality
recast. **That literal recast did NOT apply** (`sheafifyTensorUnitIso` is `a.map (η_P ⊗ η_Q)` of the
sheafification *unit*, not a `δ`/`μ` of a monoidal functor) — but the prover extracted the underlying
*principle* (keep every term in ONE monoidal instance) and closed it via a **`tensorHom`-PIN**:

1. New private helper `sheafifyTensorUnitIso_hom_eq'` states `.hom` as a SINGLE
   `a.map (MonoidalCategory.tensorHom (C := X.presheaf ⋙ forget₂ CommRingCat RingCat) η_P η_Q)`.
   Proved by `rw [sheafifyTensorUnitIso_hom_eq, ← Functor.map_comp]; congr 1;
   exact (MonoidalCategory.tensorHom_def (C := …) _ _).symm`.
2. Naturality: `rw [hom_eq', hom_eq']; erw [← Functor.map_comp, ← Functor.map_comp]; congr 1` →
   presheaf bifunctoriality; close with unit squares `hp`/`hq` + `tensorHom_comp_tensorHom`.

**The decisive, reusable lesson:** the goal's `⊗ₘ`/whiskers carry a *non-canonical* `MonoidalCategory`
instance (leaked from `Monoidal.tensorObj`/`instMS` through `sheafifyTensorUnitIso`). `rw`/`erw` of
EVERY monoidal lemma fails on it ("pattern not found", even for terms clearly present). The remedy is
to apply the monoidal lemmas **as TERMs** (`refine (… (C := …) _ _ _ _).trans ?_` / `exact (…).symm`)
with an explicit **`(C := …)`** to resolve the instance; the underscore form leaves `MonoidalCategory ?C`
a stuck metavariable. `← Functor.map_comp` similarly needs `erw`. Name trap: **`MonoidalCategory.tensor_comp`
does NOT exist** (Unknown constant); the lemma is `MonoidalCategory.tensorHom_comp_tensorHom`. A mid-session
`lean_multi_attempt` falsely reported `goals:[]` for `tensor_comp` — trust the file diagnostic, not
`multi_attempt`'s empty-goals.

### `pullbackTensorMap_natural` (D1′ target, L2004) — PARTIAL, NAMED structural blocker
- **Square-2 merge SOLVED** (iter-253's diagnosis was wrong): the two `a_Y.map`s are *right-associated*,
  so plain `← Functor.map_comp` cannot see them as one `≫`'s operands. Fix = the **reassoc** form
  `erw [← Functor.map_comp_assoc]`. This is now in the proof body; the proof advances strictly further.
- **Blocker (the STEP-B reversing signal → PLANNER decision):** Square-2's δ commutation needs
  `Functor.OplaxMonoidal.δ_natural (F := pullback φ') a.val b.val`, but **building that term FAILS**:
  `failed to synthesize MonoidalCategory (PresheafOfModules X.ringCatSheaf.obj)`. The `MonoidalCategory`
  instance is registered ONLY on the canonical `X.presheaf ⋙ forget₂ CommRingCat RingCat` spelling
  (`Presheaf/Monoidal.lean:32,104-105`), not on `X.ringCatSheaf.obj`. Defeq, but instance synthesis is
  syntactic → never fires. The STEP-A `(C := …)` term-bridge does NOT transfer (δ_natural has no slot to
  inject the instance into its domain ring). **Fix = the tscmp254 SPELLING-PIN:** a structural restatement
  of `pullbackTensorMap` + helper isos with the pullback's domain ring on the canonical `⋙ forget₂`
  spelling, keeping D2′ `pullbackTensorMap_unit_isIso` GREEN. This is a `refactor`-subagent / planner job,
  not a tactic fix.

## Lane TS-inv (`Picard/TensorObjSubstrate/DualInverse.lean`)

### `homOfLocalCompat` — sub-step (a) CLOSED, sub-step (c) ~90%, ONE isolated residual
- **`hf` RE-SIGNED** (legal: `homOfLocalCompat` is absent from `archon-protected.yaml` and has no
  compiling caller). From the unsatisfiable `HEq`-of-pullback-images form to a **sectionwise-equation**
  form: the two `f i`/`f j` section maps agree, `eqToHom`-conjugated into the fixed group `M(V) ⟶ N(V)`.
  New helper `image_preimage_of_le` (down-set identity `W.ι ''ᵁ (W.ι ⁻¹ᵁ V) = V`). Docstring corrected
  (was contradicting the body, aud253 major).
- **Sub-step (a) `IsCompatible` — CLOSED** by `exact hf i j W.left …` — matches by **definitional proof
  irrelevance** (the `eqToHom`-conjugations and `(Over.mk …).left ≡ W.left` are defeq), no `Subsingleton.elim`.
- **Sub-step (c) `𝒪_X`-linearity — built + verified except one isolated sorry:** separatedness reduction
  (`IsSheaf.section_ext`, point-based), naturality + `map_smul` reduction, the hard **connection lemma
  `hconn`** (fully proved: `g.app(op W') = homLocalSection` component, via `topSectionToHom_app` + a
  generic `subst` transport `htr` + `Subsingleton.elim` on the slice morphisms + `presheafHom_map_app ×2`),
  and the composite decomposition + M-leg `map_smul` (`erw [ConcreteCategory.comp_apply ×4, map_smul]`).
- **SOLE residual sorry (L636):** the open-immersion **ring-bridge / carrier-duality** wall. The inner leg
  `((toPresheaf _).map (f i).val).app (op P)` is `Ab`-additive only; its `(U i).ringCatSheaf(P)`-linearity
  must be reinterpreted at the `(U i)` `ModuleCat` level through the structure-ring iso `((U i).ι.appIso P)`
  and `restrictScalars`. The route is mapped (each ingredient confirmed to exist: `pushforward_obj_obj`,
  `restrictScalars`-smul is `rfl`, `(f i).val.app` is `(U i)`-linear, N-leg `map_smul`, scalar reconciliation
  since `e₂ = e₁.symm`). Maximally isolated — everything around it is proved.
- **Dead end recorded:** a *standalone* `homLocalSection_app_smul` helper FAILS instance synthesis
  (`Module (↑X.ringCatSheaf(W)) (↑M.val(W))` not found in the abstract context) → keep the linearity proof
  **inline** inside `homOfLocalCompat (c)`.

### `dual_restrict_iso` (Step-4, L256) — NOT entered
Correctly gated by the Route-2 reversing signal: STEP A surfaced a new obstacle ((c) ring-bridge), so
the lane did not split focus onto the equally-hard dual-pushforward build. Pre-existing sorry untouched.

## Key findings / patterns (this iter)
1. **The `(C := …)` term-level monoidal-lemma device** dissolves the non-canonical-`MonoidalCategory`-instance
   poisoning that gated STEP A for 5 iters. It is now the reusable idiom for the remaining D1′ squares —
   BUT it does NOT transfer to `δ_natural` (no instance slot in the domain ring), which is precisely why
   D1′ now needs the spelling-pin refactor.
2. **`erw` over `rw`/`simp`** for: the whisker-pair merge (defeq-but-not-syntactic connecting object),
   `← Functor.map_comp_assoc` (right-associated `a.map`s), and `ConcreteCategory.comp_apply` on the wrapped
   `AddCommGrpCat.Hom.hom`.
3. **Verify "PROTECTED" against `archon-protected.yaml`, not a stale in-file comment** — the iter-253 `hf:HEq`
   block was a self-imposed throttle that cost an iter.

## Blueprint markers updated (manual)
- `Picard_TensorObjSubstrate.tex`, `lem:pullback_tensor_map_natural` (proof block): added `% NOTE:`
  (tscmp254 MUST-FIX) flagging that the S2 δ-naturality sketch is Lean-inadequate — `δ_natural` cannot
  synthesize `MonoidalCategory` on the `X.ringCatSheaf.obj` spelling; the fix is the spelling-pin refactor.
- `Picard_TensorObjSubstrate.tex`, `lem:sheafify_tensor_unit_iso_natural` (proof block): added `% NOTE:`
  (tscmp254 MAJOR) flagging that the lemma is CLOSED via the `tensorHom`-PIN device, NOT the sketched
  TensorProduct induction; a writer should replace the induction prose.
- No `\mathlibok` added (no Mathlib-backed re-exports this iter — all targets are project proofs).
- No `\lean{...}` renames needed (the new helpers `sheafifyTensorUnitIso_hom_eq'` / `image_preimage_of_le`
  are private/unpinned; no pinned decl was renamed).
- No `\notready` to strip.
- `\leanok` left untouched (deterministic `sync_leanok`, iter 254, sha 7d75a59b, +17/-0). NOTE: that sync
  inserted a `\leanok` INSIDE the `\uses{}` block of `Picard_RelPicFunctor.tex:145` — a structural
  corruption flagged for the plan agent to relocate (I do not edit `\leanok`).
- lean-vs-blueprint dualinv254 confirmed the re-signed `hf` (sectionwise form) MATCHES the blueprint
  (bw254's iter-254 update held) — 0 must-fix on the DualInverse chapter.

## Blueprint doctor
ONE broken cross-reference: `Picard_RelPicFunctor.tex` has `\uses{\leanok thm:relative_pic_quotient_well_defined}`
— a `\leanok` jammed inside a `\uses{}` (the recurring corruption pattern), and/or the label
`thm:relative_pic_quotient_well_defined` is undefined. Surfaced in recommendations for the next plan agent.

## Recommendations
See `recommendations.md`.
