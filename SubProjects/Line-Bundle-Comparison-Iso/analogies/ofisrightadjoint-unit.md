# Analogy: reconcile two `leftAdjointUniq`/mate comparison isos over different-but-bridged right adjoints (B1-crux `hKEY`)

## Mode
cross-domain-inspiration

## Slug
ofisrightadjoint-unit

## Iteration
053

## Structural problem (abstracted)
Two comparison isos of left adjoints, built over right adjoints that differ by post-composition
with a forgetful/reflective functor, must be shown to coincide on objects. One iso
(`pullbackIso`) is `leftAdjointUniq` over `R₁ = pushforward φ`; the other (`pullbackValIso`, via
`sheafificationCompPullback`) is `leftAdjointUniq` of two **composite** adjunctions over
`R₂ = pushforward φ ⋙ forget`. The opaque side's unit is `Adjunction.ofIsRightAdjoint`-produced.
Residual: `(pullbackIso φ).inv.app M = (pullbackValIso f M).hom`, equivalently
`(pullbackIso φ).inv.app M = sheafCompPullback.inv.app M.val ≫ (pullback φ).map (a_X.counit.app M)`.

## Failed approaches (from directive)
- `homEquiv`/`forget.map_injective` transposition along the WHOLE composite homEquiv: circular
  (returns parent goal). **Root cause now identified**: must transpose along the INNERMOST
  presheaf-pullback adjunction, not the composite — see Analogue 1.
- `leftAdjointUniq_trans`: needs one common right adjoint; here R₁ ≠ R₂.
- `rfl`/`simp` on the two defs: not defeq (different right adjoints).
- Grep: Mathlib has zero lemmas relating `pullbackIso` ↔ `sheafificationCompPullback`.

## Analogues found

### Analogue 1: `CategoryTheory.Functor.toSheafify_pullbackSheafificationCompatibility`
`Mathlib/CategoryTheory/Sites/CoverLifting.lean:362-382` (def at :353, sectionwise formula at :385).
- **Domain**: category theory / sheaves on sites — "pushforward commutes with sheafification".
- **Same structural problem there**: `pushforwardContinuousSheafificationCompatibility` is *defined*
  as `(adj₁.comp adj₂).leftAdjointUniq (adj₃.comp adj₄)` — a `leftAdjointUniq` of two COMPOSITE
  adjunctions (Lan∘sheafify vs sheafify∘pushforward), the EXACT shape of the project's
  `sheafificationCompPullback`. The lemma computes its `.hom.app F` **pushed through the forgetful
  `sheafToPresheaf` functor**, against a `toSheafify` (sheafification unit) — the literal twin of
  `forget (sheaf-unit)` vs the presheaf composite.
- **Technique (the non-circular telescope, ~15 lines)**:
  1. `change` the goal to expose `sheafToPresheaf.map ((adj₁.comp adj₂).leftAdjointUniq …).hom.app F`.
  2. `apply (adj₁.homEquiv _ _).injective` — transpose along the **innermost** adjunction `adj₁`
     (the Lan / presheaf-pullback one), NOT the whole composite. **This is what breaks circularity.**
  3. `have eq := (adj₁.comp adj₂).unit_leftAdjointUniq_hom_app (adj₃.comp adj₄) F` — the defining
     unit triangle (the project already has this as `hpin`).
  4. `rw [Adjunction.comp_unit_app, Adjunction.comp_unit_app, comp_map, Category.assoc] at eq` —
     **expand both composite-adjunction units**, exposing the sheafification unit explicitly.
  5. `rw [adj₁.homEquiv_unit, Functor.map_comp, eq]`, transpose back
     `apply (adj₁.homEquiv _ _).symm.injective`, then
     `simp [homEquiv_counit, homEquiv_unit, unit_naturality]`.
  6. Close with one component coherence (there
     `sheafAdjunctionCocontinuous_unit_app_hom`; here the `pushforward_forget` square / the
     X-counit naturality `hnat`).
- **Mapping to project**: `adj₁ ↦ pullbackPushforwardAdjunction φ.hom` (presheaf, the one whose
  `homEquiv` the project ALREADY transposes against in `H1inv_app_eq_pullbackVal_restrict`);
  `adj₂ ↦ sheafificationAdjunction (𝟙 R.obj)`; `adj₃.comp adj₄ ↦ A = a_X.comp pb_s`;
  `sheafToPresheaf ↦ SheafOfModules.forget`; `toSheafify ↦ sheafification unit η`; `eq ↦ hpin`;
  step-6 coherence ↦ `hnat` (X-counit naturality of `pb_s.unit`). The two project inputs
  `hnat`/`hpin` are EXACTLY steps 6 and 3.
- **Porting cost**: LOW. Both non-circular inputs already typecheck in-file; the missing idiom is
  steps 2+4 (`Adjunction.comp_unit_app` expansion after transposing along the *inner* adjunction).
- **Verdict**: ANALOGUE_FOUND.

### Analogue 2: `Adjunction.leftAdjointCompIso` + `conjugateEquiv_leftAdjointCompIso_inv`
`Mathlib/CategoryTheory/Adjunction/CompositionIso.lean:72,82` (and `leftAdjointIdIso` :44).
- **Domain**: category theory — comparison isos of left adjoints from right-adjoint composition isos.
- **Same structural problem**: given an iso of composite right adjoints `G₂₁ ⋙ G₁₀ ≅ G₂₀`, build the
  comparison iso of left adjoints `F₀₁ ⋙ F₁₂ ≅ F₀₂`, **characterized** by
  `conjugateEquiv (adj₀₁.comp adj₁₂) adj₀₂ (·.inv) = e₀₁₂.hom`. Crucially `conjugateEquiv adj₁ adj₂`
  ranges over **genuinely different** right adjoints R₁, R₂ (unlike `leftAdjointUniq`, which forces
  R₁ = R₂ and is the source of the project's rigidity). `leftAdjointUniq adj₁ adj₂` is literally
  `conjugateIsoEquiv adj₁ adj₂ (Iso.refl G)` — the conjugate of the identity (Unique.lean:36).
- **Technique**: never compare two `leftAdjointUniq`s directly; compute each comparison's
  `conjugateEquiv` image (a map between the right adjoints) and match those, using the `@[simp]`
  pins `conjugateEquiv_leftAdjointCompIso_inv`, `conjugateEquiv_pullbackComp_inv`
  (PullbackContinuous.lean:176), `conjugateEquiv_pullbackId_hom` (:143).
- **Mapping to project**: reformulate `hKEY` as: both `pullbackIso.inv.app M` and
  `pullbackValIso.hom`(=`sheafCompPullback.inv.app M.val ≫ pullback.map ε`) have the same image
  under `conjugateEquiv (a_X.comp pb_s) B`; the RHS image is forced by
  `conjugateEquiv_comp` + the leftAdjointUniq pins, the LHS by the X-counit naturality.
- **Porting cost**: LOW–MEDIUM. Needs the bridge nat-iso `R₂ ≅ R₁ ⋙ forget` named explicitly.
- **Verdict**: ANALOGUE_FOUND.

### Analogue 3: `conjugateEquiv_whiskerLeft` / `conjugateEquiv_comp`
`Mathlib/CategoryTheory/Adjunction/Mates.lean:525,338`.
- **Domain**: category theory — mate-calculus functoriality.
- **Same structural problem**: `conjugateEquiv (adj.comp adj₁) (adj.comp adj₂) (whiskerLeft L τ) =
  whiskerRight (conjugateEquiv adj₁ adj₂ τ) R` — i.e. **`leftAdjointUniq` commutes with
  `Adjunction.comp` on the left** (conjugate of left-whiskered = right-whiskered conjugate).
  Plus `conjugateEquiv_comp` splits a conjugate over a composite into a leg-by-leg telescope.
- **Technique**: the project's OWN B2 closure ("conjugate telescope" via repeated
  `← conjugateEquiv_comp`, iter-050, memory `b2-closed-conjugate-telescope-iter050`). It already
  works here — B1-crux is the same shape with one extra sheafification-counit leg.
- **Mapping to project**: B1-crux IS B2 + the `a_X.counit` (=ε) leg. Reuse the B2 telescope,
  inserting `conjugateEquiv_whiskerLeft` for the `a_X.comp (–)` step and `hnat` for the ε leg.
- **Porting cost**: LOW (machinery already proven in `TensorObjInverse.lean` for B2).
- **Verdict**: ANALOGUE_FOUND.

### Analogue 4 (PARTIAL): `pushforwardContinuousSheafificationCompatibility_hom_app_hom`
`Mathlib/CategoryTheory/Sites/CoverLifting.lean:385`.
- Gives the **sectionwise `sheafifyLift` formula** for the sites-level twin of
  `sheafificationCompPullback`. Shows the project's `sheafificationCompPullback` *could* be given
  real API (it is a bare `noncomputable def` with none). Not directly reusable (plain sheaves vs
  SheafOfModules) but confirms the def is canonical and the unit-triangle route is the intended one.
- **Verdict**: PARTIAL_ANALOGUE.

## Discarded
- `leftAdjointUniq_trans` — directive's failed list (needs common right adjoint).
- `rightAdjointUniq` family — wrong variance (we compare left adjoints).
- `Adjunction.ofNatIsoRight` (Basic.lean:521) — transports an adjunction across a right-adjoint
  iso, but doesn't itself yield the comparison-unit coherence; would rebuild more than Analogue 1.

## Recommendation
Close `hKEY` by porting **Analogue 1** (`toSheafify_pullbackSheafificationCompatibility`): transpose
along the **innermost** `PresheafOfModules.pullbackPushforwardAdjunction φ.hom`, feed `hpin`
(=`unit_leftAdjointUniq_hom_app A B`), then `rw [Adjunction.comp_unit_app, Adjunction.comp_unit_app]`
to expand the composite units into sheafification-unit + inner-unit, transpose back, and discharge
the residual with `hnat` (X-counit naturality). The project's two inputs `hnat`/`hpin` are exactly
the precedent's two non-circular inputs — the only missing move is "transpose along the inner adj,
not the composite, then `comp_unit_app`". Expected ≲25 LOC, not the feared 80–150.

**Do NOT redefine** `pullbackValIso f M := (pullbackIso φ).symm.app M` now: although its type matches
and would make `hKEY` `rfl`, it would break the already-CLOSED `pullbackValIso_comp_leg` coherences
(which were proven from the `sheafificationCompPullback` definition). Net irreducible work is the
same; relocating it is not worth breaking green lemmas at iter-053. (If starting fresh, the
`pullbackIso`-based definition WOULD be preferable — it inherits `conjugateEquiv_pullbackComp_inv` /
`leftAdjointCompIso_assoc` for the comp-coherences. Record for any future refactor.)
