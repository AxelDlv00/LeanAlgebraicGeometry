# AlgebraicJacobian/Cotangent/GrpObj.lean

## Iter-140 prover lane: piece (i.b) Step 2 sub-sorry closure (BUNDLED 3 sub-sorries)

**Result: PARTIAL (0 of 3 sub-sorries fully closed substantively; structural
refactor advances on IsIso path; d_app + d_map setup scaffolding committed).**

Sorry count at iter-140 close on this file: **3 decls / 3 inline** (unchanged
from iter-140 entry). File compiles cleanly with `lake env lean
AlgebraicJacobian/Cotangent/GrpObj.lean` (no errors). No new axioms.

### Substantive deliverables this iter

1. **Helper added**: `isIso_of_app_iso_module` (5 lines, private, namespace
   `AlgebraicGeometry.GrpObj`) implementing the iter-139 mathlib-analogist
   verified iso-reflection bridge for `PresheafOfModules` morphisms (per
   `analogies/isiso-basechange-along-proj-two-inv.md` Decision 2). Requires
   `import Mathlib.CategoryTheory.Functor.ReflectsIso.Balanced` (added).
   Tested standalone via `lean_run_code` to typecheck before committing to
   the file.

2. **IsIso sorry restructured**: at L688–L689,
   `letI : IsIso (basechange_along_proj_two_inv G) := sorry`
   is now
   `letI : IsIso (basechange_along_proj_two_inv G) :=
       isIso_of_app_iso_module (basechange_along_proj_two_inv G) (fun _ => sorry)`.
   This is a substantive structural refactor: the `sorry` is now narrowed
   from "is the whole presheaf morphism an iso" to "is each per-open
   ModuleCat-morphism `(basechange_along_proj_two_inv G).app X` an iso".
   The remaining sub-sorry has explicit type `∀ X, IsIso (...)`. The
   per-open closure (against `tensorKaehlerEquiv.symm` modulo the
   chart-unfolding) is the residual iter-141+ target.

3. **d_app scaffolding** (L602–L624): added `change (CommRingCat.KaehlerDifferential.D _).d _ = 0`
   that successfully beta-reduces the goal from
   `(fun b => ...) ((φ_G.app X).hom a) = 0`
   to the clean form
   `(KD φ_LHS_at_(snd⁻¹X)).d ((ψ.app X).hom ((φ_G.app X).hom a)) = 0`.
   Added 16-line docstring documenting the closure recipe: produce a
   factoring `h : Source ⟶ ((pullback fst.left.base).obj G.left.presheaf).obj (snd⁻¹X)`
   with `h ≫ (φ_LHS.app (snd⁻¹X)) = (φ_G.app X) ≫ (ψ.app X)`, then apply
   `Derivation.map_algebraMap`. The factoring-lemma pattern was validated
   standalone via `lean_run_code`:
   ```
   example (A B C : CommRingCat) (f1 : A ⟶ B) (g : C ⟶ B) (k : A ⟶ C)
       (hcomm : k ≫ g = f1) (a : A) :
       (CommRingCat.KaehlerDifferential.D g).d (f1.hom a) = 0 := by
     have heq : f1.hom a = g.hom (k.hom a) := by rw [← hcomm]; rfl
     rw [heq]
     letI : Algebra C B := g.hom.toAlgebra
     letI : Module C (CommRingCat.KaehlerDifferential g) :=
       Module.compHom _ (algebraMap C B)
     letI : IsScalarTower C B (CommRingCat.KaehlerDifferential g) :=
       IsScalarTower.of_algebraMap_smul (fun _ _ => rfl)
     exact (CommRingCat.KaehlerDifferential.D g :
       Derivation C B (CommRingCat.KaehlerDifferential g)).map_algebraMap _
   ```

4. **d_map scaffolding** (L608–L626): renamed binders from `_ _ _ _` to
   `X Y f x` and added 18-line docstring with the two-piece chase recipe
   (ψ-naturality from `Scheme.Hom.c.naturality`, plus
   `relativeDifferentials'_map_d` via the
   `PresheafOfModules.DifferentialsConstruction.relativeDifferentials'_map_d`
   Mathlib lemma found via `lean_loogle`). Attempted `change`-based
   scaffold but reverted (caused deterministic timeout in `whnf` at the
   d_map field elaboration site, even at maxHeartbeats=200000).

### d_app: detailed gap

Goal (after `change`):
```
(KaehlerDifferential.D φ_LHS_at_(snd⁻¹X)).d ((ψ.app X).hom ((φ_G.app X).hom a)) = 0
```
where:
- `φ_LHS = ((pullbackPushforwardAdjunction).homEquiv).symm (fst G G).left.c`
- `φ_G = ((pullbackPushforwardAdjunction).homEquiv).symm G.hom.c`
- `ψ = (Scheme.Hom.toRingCatSheafHom (snd G G).left).hom`

**Closure recipe** (per blueprint `RigidityKbar.tex:594–651` + iter-140
prover validation):

1. Use `(fst G G).w` + `(snd G G).w` (Over morphism property) to get
   `(fst G G).left ≫ G.hom = (snd G G).left ≫ G.hom`.
2. Apply `LocallyRingedSpace.comp_c_app` to lift this to the structure-sheaf
   level on each open:
   `G.hom.c.app X ≫ (fst G G).left.c.app (G.hom⁻¹ X)
    = G.hom.c.app X ≫ (snd G G).left.c.app (G.hom⁻¹ X)`.
3. Adjunction-transpose this identity (via
   `pullbackPushforwardAdjunction.homEquiv`) to obtain the corresponding
   identity on the φ_G / φ_LHS / ψ compatibility morphisms.
4. Use the resulting identity to construct
   `h : ((pullback G.hom.base).obj (Spec k).presheaf).obj X ⟶
        ((pullback fst.left.base).obj G.left.presheaf).obj (snd⁻¹X)`
   such that
   `h ≫ (φ_LHS.app (snd⁻¹X)) = (φ_G.app X) ≫ (ψ.app X)`.
5. Apply the factoring-lemma pattern (validated above) to discharge the
   d_app goal.

**Estimated LOC**: ~40–80 LOC of categorical chase + ~10 LOC for the
algebra/module/isscalartower instance discharge.

**Iter-140 prover dead-end avoidance**:
- The `change` + `simp` approach (autoParam default) fails because the
  metavariables `?m.161, .162, .130, .91` in the Derivation'.mk lambda
  context aren't fully elaborated at the call site, leaving the goal in a
  shape that `simp`/`exact?` can't progress on.
- The structural `change` *does* succeed once `intro a` is named (iter-140
  validated this).

### d_map: detailed gap

Goal (after intros `X Y f x`):
```
(KD φ_LHS_at_(snd⁻¹Y)).d ((ψ.app Y).hom (G.left.presheaf.map f .hom x))
= ((pushforward ψ).obj LHS).map f .hom
    ((KD φ_LHS_at_(snd⁻¹X)).d ((ψ.app X).hom x))
```

**Closure recipe**:

1. Apply ψ-naturality (`NatTrans.naturality` for
   `(Scheme.Hom.toRingCatSheafHom (snd G G).left).hom`):
   `(ψ.app Y).hom (G.left.presheaf.map f .hom x)
    = (G ⊗ G).left.presheaf.map (snd⁻¹f) .hom ((ψ.app X).hom x)`.
2. Apply `PresheafOfModules.DifferentialsConstruction.relativeDifferentials'_map_d`
   (Mathlib name verified iter-140): on the RHS, identifies
   `LHS.map (snd⁻¹f) .hom ((KD φ_LHS_X).d ((ψ.app X).hom x))`
   with
   `(KD φ_LHS_Y).d ((G ⊗ G).left.presheaf.map (snd⁻¹f) .hom ((ψ.app X).hom x))`.
3. The `(pushforward ψ).obj LHS .map f = LHS.map (snd⁻¹f)`
   identification is **definitional** (transparent per
   `Mathlib/Algebra/Category/ModuleCat/Presheaf/Pushforward.lean:39, 86`
   — `pushforward = pushforward₀ ∘ restrictScalars`).

**Estimated LOC**: ~30–60 LOC.

**Iter-140 prover dead-end avoidance**:
- The `change (CommRingCat.KaehlerDifferential.D _).d _ = _` approach
  *does NOT work* for d_map — causes a deterministic `whnf` timeout at
  maxHeartbeats=200000 (the RHS contains the
  `((pushforward ψ).obj LHS).map f` which is opaque to `whnf`
  reduction). Reverted; the d_map scaffolding stays at the unmodified
  `sorry` with the recipe documented.

### IsIso: detailed gap

The per-open sorry at L689 has type
`∀ (X : (Opens G.left)ᵒᵖ), IsIso ((basechange_along_proj_two_inv G).app X)`.

**Closure recipe** (Route (b'2) per
`analogies/isiso-basechange-along-proj-two-inv.md` Decision 1):

1. Per-open identification of `(basechange_along_proj_two_inv G).app X`
   with `KaehlerDifferential.tensorKaehlerEquiv.symm` on affines (modulo
   the chart-unfolding of `((pullback ψ).obj M_G).obj X`).
2. Build `pullbackObjEquivTensor` helper (~30–60 LOC; shared with Route
   (a); upstream-PR candidate).
3. Build chart-level `Algebra.IsPushout`-from-affine-product helper
   (~80–150 LOC; shared with Route (a); upstream-PR candidate). Per
   `analogies/kaehler-tensorequiv-presheafpullback.md` Decision 2 — build
   from `CommRingCat.isPushout_iff_isPushout`, `pullbackSpecIso`,
   `isPullback_SpecMap_of_isPushout`.
4. Apply `tensorKaehlerEquiv_symm_D_tmul` for the value identity
   `D b ↦ 1 ⊗ D b`.

**Estimated LOC**: ~150–300 LOC total (iter-141+ target).

**Iter-140 progress**: The structural reduction from "IsIso of presheaf
morphism" to "per-open IsIso" via the helper is a key step — it isolates
the chart-level identification work from the natural-transformation
iso-check, which can be done independently. The 5-line bridge helper is
upstream-PR candidate (mirrors `Scheme.Modules.Hom.isIso_iff_isIso_app`
in `Mathlib/AlgebraicGeometry/Modules/Sheaf.lean:132`).

### Verification

- `lake env lean AlgebraicJacobian/Cotangent/GrpObj.lean` — green, 3
  `declaration uses sorry` warnings at L573 + L670 + L806.
- No new axioms introduced.
- No protected signatures touched.

### Iter-141 prover handoff

If iter-141 prover targets this lane:

1. **d_app**: implement the 5-step recipe above. Start with steps 1–2
   (categorical commutativity + comp_c_app); the adjunction-transpose
   bridge is the load-bearing chase.
2. **d_map**: implement the 3-step recipe above. Start with the
   ψ-naturality rewrite; `relativeDifferentials'_map_d` is the
   load-bearing Mathlib lemma.
3. **IsIso per-open**: build the `pullbackObjEquivTensor` helper first
   (smallest unit), then the `Algebra.IsPushout` chart helper, then
   apply `tensorKaehlerEquiv_symm_D_tmul` per-open.

### Blueprint marker recommendations (review-agent action)

The Lean target
`AlgebraicGeometry.GrpObj.relativeDifferentialsPresheaf_basechange_along_proj_two`
(`Cotangent/GrpObj.lean:670`) still contains `letI ... := isIso_of_app_iso_module ... (fun _ => sorry)`,
so the `\leanok` marker on the proof block of `lem:GrpObj_omega_basechange_proj`
in `RigidityKbar.tex:505` remains a candidate sync_leanok mis-mark
(iter-141+ doctor-skill consult deferred; was iter-140 watchpoint).

The new helper `isIso_of_app_iso_module` is private and not
blueprint-referenced.
