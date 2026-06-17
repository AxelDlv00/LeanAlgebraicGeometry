# AlgebraicJacobian/RiemannRoch/WeilDivisor.lean

## Session summary (iter-202, Lane WD-A4a Sub-build 3)
- Built axiom-clean: `Scheme.PrimeDivisor.functionFieldIso_compat` (step 1, morphism-level),
  `Scheme.PrimeDivisor.order_eq_order_restrict` (step 2, HARD BAR endpoint).
- **HARD BAR MET**: both step (1) AND step (2) closed axiom-clean (kernel triple only).
- Sorry count: **78 → 78 across project; file local sorries unchanged** (no new sorry added;
  the 3 pre-existing bodied sorries — `rationalMap_order_finite_support` non-zero branch,
  `principal_degree_zero` non-constant branch, and the Hartshorne II.6.9 `[∞]` typed pin —
  are all USER-blocked / off-limits and were not touched).
- Verdict: **Real progress** — 2 axiom-clean declarations added.

## `Scheme.PrimeDivisor.functionFieldIso_compat` (≈ lines 572–592)
- **Statement (morphism-level, in `CommRingCat`)**: for integral `X`, nonempty integral
  open `U`, prime divisor `Y` with `Y.point ∈ U`,
  `stalkSpec_U (gp_U ⤳ Y) ≫ functionFieldIso U .hom
     = (stalkIso U Y hYU).hom ≫ stalkSpec_X (gp_X ⤳ Y.point)`
  where the horizontal maps are the canonical `stalkSpecializes` maps to the respective
  generic points (= the algebra maps `O_{·,Y} → K(·)` of `stalkFunctionFieldAlgebra`).
- **Approach**: germ-chase via `TopCat.Presheaf.stalk_hom_ext`. After `intro V hxV`:
  - local `hcongr : (X.presheaf.stalkCongr e).hom = X.presheaf.stalkSpecializes e.ge := rfl`
    (no Mathlib `stalkCongr_hom` lemma exists; the `.hom` projection is `rfl`).
  - `simp only [Scheme.PrimeDivisor.stalkIso, Scheme.Opens.functionFieldIso, Iso.trans_hom,
    restrictToOpen_point, hcongr]` to unfold defs + normalize the point to `⟨Y.point,hYU⟩`.
  - `simp only [germ_stalkSpecializes_assoc, Scheme.Opens.germ_stalkIso_hom_assoc]` reduces
    both sides to `germ (U.ι ''ᵁ V) · ≫ stalkSpecializes ·`.
  - close with `(germ_stalkSpecializes _ _ _).trans (germ_stalkSpecializes _ _ _).symm`
    (term mode — plain `rw [germ_stalkSpecializes]` would NOT match the final
    `germ ≫ stalkSpecializes`; term-mode unifies via the expected type).
- **Result**: RESOLVED — `#print axioms` = `{propext, Classical.choice, Quot.sound}`.
- **Dead-end note**: `rw [TopCat.Presheaf.germ_stalkSpecializes]` fails ("pattern not found")
  on the terminal `germ ≫ stalkSpecializes` even though it is syntactically present; use the
  term-mode `germ_stalkSpecializes _ _ _` instead.

## `Scheme.PrimeDivisor.order_eq_order_restrict` (≈ lines 594–621)
- **Statement**: `order Y (functionFieldIso U .commRingCatIsoToRingEquiv f)
     = order (restrictToOpen U Y hYU) f` for `f : U.toScheme.functionField`, under
  `[IsIntegral X] [IsLocallyNoetherian X] [IsRegularInCodimensionOne X] [Nonempty U]
   [IsIntegral U.toScheme]`. All downstream `Ring.KrullDimLE 1` /
  `IsRegularInCodimensionOne U.toScheme` / `IsLocallyNoetherian U.toScheme` instances are
  synthesized automatically (via `instKrullDimLEStalk`, `instOpen`, and Mathlib's
  open-subscheme instances).
- **Approach**: prove the pointwise `h_compat` from `functionFieldIso_compat`:
  `congrArg (fun φ => (CommRingCat.Hom.hom φ) r) functionFieldIso_compat`, then
  `simp only [CommRingCat.hom_comp, RingHom.coe_comp, Function.comp_apply]`. The resulting
  `happ` matches the goal **by `rfl`/defeq**: `e.commRingCatIsoToRingEquiv x = e.hom.hom x`
  is `rfl`, and `algebraMap (stalk x) functionField = (stalkSpecializes …).hom` is defeq
  (the `stalkSpecializes` proof args differ only by proof-irrelevant `· ∈ univ` witnesses).
  So `exact happ` closes `h_compat`. The main goal then follows by
  `unfold order; rw [ordFrac_stalkIso_naturality U Y hYU _ hcompat f]`.
- **Result**: RESOLVED — `#print axioms` = `{propext, Classical.choice, Quot.sound}`.

## PUSH-BEYOND (terminal closure of `rationalMap_order_finite_support` non-zero branch)
- NOT attempted in code: SCOPE FENCE + USER block on signature strengthening
  (`[IsLocallyNoetherian X]` → `[IsNoetherian X]`/`[CompactSpace X]`). The existing
  in-file comment block on that sorry already documents the full resolution skeleton
  (affine-chart reduction + Dedekind height-1 finiteness). `order_eq_order_restrict` is
  exactly the open-chart naturality the terminal closure (iter-203) will consume:
  it lets `support (Y ↦ order Y f)` be pulled back to each affine chart `U_i`.

## Handoff for plan/review agents
- **Blueprint**: `RiemannRoch_WeilDivisor.tex` §3-Sub-build-3 (lines ~441–464) describes
  this work in prose but has **no `\lean{...}`-pinned environment** for the two new
  declarations. Recommend the plan agent add `\begin{lemma}…\lean{...}` environments for
  `AlgebraicGeometry.Scheme.PrimeDivisor.functionFieldIso_compat` and
  `AlgebraicGeometry.Scheme.PrimeDivisor.order_eq_order_restrict` so `sync_leanok` can mark
  them `\leanok`. Both are ready for `\leanok` (axiom-clean, no sorry).
- **iter-203 cascade**: with `order_eq_order_restrict` in place, the terminal closure of
  `rationalMap_order_finite_support` becomes a finite-affine-cover bound — but remains gated
  on the USER-blocked `[IsNoetherian X]`/`[CompactSpace X]` signature strengthening.

## Why I stopped
Real progress: 2 axiom-clean declarations added (`functionFieldIso_compat` lines 572–592,
`order_eq_order_restrict` lines 594–621). The assigned Sub-build 3 chain (step 1 mechanism +
step 2 sorry-reducing-direction endpoint) is fully closed and axiom-clean — the HARD BAR.
No further axiom-clean progress is available in-file: the only remaining open targets are the
USER-blocked / fenced sorries (signature strengthening or Route-C-paused), which I must not
touch. No unattempted approaches remain in comments.
