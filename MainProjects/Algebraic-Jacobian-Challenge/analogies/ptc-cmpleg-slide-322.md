# Analogy: cmp_leg composition coherence + sliding it into a giant goal under relaxed transparency

## Mode
cross-domain-inspiration

## Slug
ptc-cmpleg-slide-322

## Iteration
322

## Structural problem (abstracted)
Two coupled shapes. (1) A comparison 2-cell `cmp_g : a∘Fp_g ⟹ Pb_g∘a` (a = sheafification, Fp =
presheaf pullback, Pb = sheaf pullback), built as `cmp_g = unit ≫ R.map(I_g)` from a sheaf-level iso
`I_g`; we need its **composition coherence** under `h∘f` (the cocycle `cmp_{hf} = Fp_h.map(cmp_f) ≫
cmp_h ≫ R.map(comp-iso)`). (2) An established **idiom for sliding a verified naturality lemma into a
large categorical goal** without `kabstract` whnf-exploding on a `respectTransparency false` defeq.

## Failed approaches (from directive)
- Monolithic paste of all 4 squares under relaxed transparency → whnf-explosion (iter-319/320).
- Extract slide as standalone `scPb_slide`, `rw` it INTO the giant goal → same defeq detonation (iter-321).
- `simp [pullbackValIso, ← NatTrans.naturality, ← Functor.map_comp_assoc]` on `cmp_leg` → max-recursion loop.

## Analogues found

### Analogue: `CategoryTheory.Adjunction.homEquiv_unit` / `homEquiv_naturality_{left,right}` (`Mathlib.CategoryTheory.Adjunction.Basic`)
- **Domain**: adjunction transpose calculus.
- **Same structural problem there**: `homEquiv_unit adj X Y f = unit.app X ≫ R.map f`. This is
  *literally* the formula defining `cmp_g`: `cmp_g M = η.app(Fp_g M.val) ≫ forget(I_g M).hom =
  (sheafificationAdjunction.homEquiv _ _) (I_g M.hom)`, where `I_g M.hom : a(Fp_g M.val) ⟶ Pb_g M` is
  the **already-proven** sheaf-level comparison (`pullbackValIso`/`sheafificationCompPullback`). So
  `cmp_g = homEquiv ∘ (sheaf comparison)`, and `homEquiv` is an injective `Equiv`.
- **Technique**: the composition coherence `cmp_leg` is the **image under `homEquiv` of the
  already-proven sheaf coherence** `pullbackValIso_comp` (Sq4, in-file L738, CLOSED) — NOT a fresh
  ~100 LOC mate re-derivation. Unfold the homEquiv-image with three naturality lemmas:
  - `homEquiv_naturality_left adj f g : homEquiv (F.map f ≫ g) = f ≫ homEquiv g`
    → produces the **leading `PC.hom M.val`** (presheaf `pullbackComp`) factor of `cmp_leg`.
  - `homEquiv_naturality_right adj f g : homEquiv (f ≫ g) = homEquiv f ≫ R.map g`
    → produces the **trailing `forget(pbc M).hom`** and the `forget(pvi_·)` value-iso factors.
  - `homEquiv_unit` (above) → introduces the `η` unit at each leaf.
  - (`homEquiv_naturality_left_symm` for the inner `Fp_h.map(cmp_f)` leg if approached symm-side.)
- **Mapping to project**: `cmp_g M := η_·.app(Fp_g M.val) ≫ forget(pullbackValIso g M).hom` is
  `(PresheafOfModules.sheafificationAdjunction (𝟙 …)).homEquiv _ _` applied to
  `(pullbackValIso g M).hom` lifted to the sheaf. Apply that `homEquiv` to the equation
  `pullbackValIso_comp h f M` (which already states the SHEAF coherence
  `(pvi (h≫f) M).hom ≫ (pullbackComp h f).inv.app M = Ψ ≫ (pullback h).map (pvi f M).hom`), then
  rewrite by the three naturality lemmas. Injectivity (`Equiv.apply_eq_iff_eq` / just `congrArg`) does
  the rest. The leading `PC.hom` and trailing `forget(pbc).hom` of the target `cmp_leg` statement are
  exactly what `naturality_left`/`naturality_right` emit — strong evidence this is the right transpose.
- **Porting cost**: **low** (~20–40 LOC). All four lemmas are Mathlib; `pullbackValIso_comp` is already
  proved in-file. No new mate calculus.
- **Verdict**: ANALOGUE_FOUND.

### Analogue: `CategoryTheory.Functor.toSheafify_pullbackSheafificationCompatibility` (`Mathlib.CategoryTheory.Sites.CoverLifting`)
- **Domain**: sites / sheafification (the exact one-shelf-over precedent).
- **Same structural problem there**: for `G : C ⥤ D` cocontinuous+continuous and `F : Dᵒᵖ ⥤ A`,
  `toSheafify J (G.op ⋙ F) ≫ (G.pushforwardContinuousSheafificationCompatibility A J K).hom.app F).hom
   = G.op ◁ (toSheafify K F)`. This is **precisely the single-altitude `cmp`**: the sheafification unit
  composed with the sheafify∘pullback comparison iso equals the pulled-back unit. The comparison iso
  `pushforwardContinuousSheafificationCompatibility` is the general (sheaves-in-`A`) parent of the
  project's `SheafOfModules.sheafificationCompPullback` (which is itself Mathlib,
  `Mathlib.Algebra.Category.ModuleCat.Sheaf.PullbackContinuous`).
- **Technique**: proved by the **universal property of sheafification** — two maps out of a sheafified
  presheaf agree iff they agree after `toSheafify` (`toSheafify` is the unit; `toSheafify_naturality`,
  `Mathlib.CategoryTheory.Sites.ConcreteSheafification`). I.e. reduce the presheaf identity to the
  sheaf identity by precomposing with the unit and quoting unit-naturality — the **same move** as the
  `homEquiv` analogue above (homEquiv = `unit ≫ R.map`).
- **Mapping to project**: Mathlib gives the *single-altitude* template; the project needs the
  *composition-coherence (h∘f)* version. There is no Mathlib `h∘f` lemma, but mirroring this proof at
  the composition altitude is exactly the `homEquiv`-of-`pullbackValIso_comp` recipe above. Read this
  lemma's proof as the pattern; don't expect to instantiate it directly (module vs. general-A; the
  project's iso is `sheafificationCompPullback`, not the type-level `…Compatibility`).
- **Porting cost**: **low** (template only — confirms the homEquiv route is the canonical one).
- **Verdict**: ANALOGUE_FOUND (as confirmation/template for analogue 1).

### Analogue: `CategoryTheory.mateEquiv_vcomp` / `mateEquiv_hcomp` / `conjugateEquiv_comp` (`Mathlib.CategoryTheory.Adjunction.Mates`)
- **Domain**: abstract mate calculus (the engine already used in-file for the SHEAF side).
- **Same structural problem there**: `mateEquiv_vcomp`/`mateEquiv_hcomp` ARE the composition coherence
  of mates — `mateEquiv (α.hComp β) = (mateEquiv α).vComp (mateEquiv β)` etc. The in-file
  `sheafificationCompPullback_comp` (L459) already discharges the SHEAF coherence via
  `conjugateEquiv_comp` (×3) + `conjugateEquiv_whiskerLeft/Right` at the **abstract 2-cell level**,
  where every term is a small `NatTrans` and **no `Scheme.Modules.pullback` defeq is ever forced**.
- **Technique — the key lesson for BOTH sub-problems**: the explosion in (2) happens *only because* the
  proof first assembled the giant concrete 13-factor goal and then tries to slide inside it. Mathlib
  proves these exact coherences **abstractly** (on `mateEquiv`/`TwoSquare`/`conjugateEquiv`), never
  unfolding the functor. The project ALREADY did this for the sheaf side; `cmp_leg` should likewise be
  obtained abstractly (homEquiv-transpose, analogue 1) and the per-leg result fed into the assembly —
  rather than re-deriving it inside the post-Step-D goal.
- **Mapping to project**: do NOT re-run `mateEquiv_*` for `cmp_leg`; analogue 1 (homEquiv-transpose of
  the already-`mateEquiv`-proved sheaf coherence) is strictly cheaper. Listed because it diagnoses WHY
  the slide explodes: the project is operating on a concrete goal Mathlib never builds.
- **Porting cost**: n/a (diagnostic).
- **Verdict**: PARTIAL_ANALOGUE (don't port directly; it's the in-file sheaf-side engine).

## The slide problem (2): established idioms to avoid kabstract whnf-explosion

Root cause: `rw`/`erw`/`reassoc_of%`/`slice` all call `kabstract`, which traverses the WHOLE goal
testing defeq of every candidate subterm against the slide LHS. Under `respectTransparency false` the
defeq `Scheme.Modules.pullback ≟ SheafOfModules.pullback φ_h` whnf-explodes (~6.4M hb / 9 min), and
kabstract triggers it once per candidate position in the 13-factor goal. Ranked idioms (lowest cost
first):

1. **Freeze the detonating subterm with `set` / `generalize` BEFORE the slide.**
   `set Pbh := Scheme.Modules.pullback h with hPbh` (or `generalize` the whole
   `(Scheme.Modules.pullback h).map _` head) replaces it with an **opaque local fvar**; kabstract then
   matches the fvar *syntactically* and never whnf's into `pullback`, so the explosion can't fire.
   After the slide, `rw [← hPbh]`/leave folded. LOW cost. **Try first.** (Caveat: `set` the SAME head
   the slide's LHS mentions, so the pattern still matches.)

2. **Continuation-lemma at DEFAULT transparency** (the project's own iter-322 entry point). The slide
   needs NO relaxed transparency — only Step A's Sq1 `rw` did. Split the proof AFTER Step D into a
   lemma WITHOUT `set_option backward.isDefEq.respectTransparency false`; the slide then runs like
   D1′'s `pullbackTensorMap_natural` `erw [reassoc_of% …]` paste, which does not explode. Only blocker
   is re-pinning each `⊗ₘ`'s `(C := PresheafOfModules (W.presheaf ⋙ forget₂ …))` carrier (the
   pretty-printer drops it). LOW–MED cost. Removes the *cause*, not just the symptom.

3. **`conv`-focused `rw`.** `conv` navigates to the single tensor leg, then `rw [scPb_slide …]` there.
   kabstract still runs but over the FOCUSED subterm, not the 13-factor goal, so the `pullback` defeq
   is tested ~once instead of dozens of times. LOW cost; standard remedy for slow/wrong-occurrence `rw`
   in large goals.

4. **Term-mode `calc` / `Eq.trans` with `scPb_slide` and `reassoc_of% scPb_slide` as SUPPLIED
   motives.** `exact`/`calc` unify the *stated* intermediate term against the goal at the root
   (directed unification) — they do NOT run kabstract's whole-goal search. Each calc step quotes the
   precomputed equality; the expensive defeq is only hit if a leaf genuinely differs. MED cost (must
   write the intermediate terms with `(C := …)` pins, as in #2).

Best combination: **#2 (continuation lemma, default transparency) as the primary fix; #1 (`set`-freeze
`Scheme.Modules.pullback h`) as the fallback if any slide must still run under relaxed transparency;
#3 (`conv`) to localize whichever rewrite remains.**

## Top suggestion
Do BOTH sub-problems abstractly, mirroring the sheaf side. (1) Prove `cmp_leg` as the **`homEquiv`
transpose of the already-proven `pullbackValIso_comp`**: read
`CategoryTheory.Adjunction.homEquiv_unit` + `homEquiv_naturality_left` + `homEquiv_naturality_right`
(`Mathlib.CategoryTheory.Adjunction.Basic`) and the template proof of
`Functor.toSheafify_pullbackSheafificationCompatibility` (`Mathlib.CategoryTheory.Sites.CoverLifting`);
apply `(PresheafOfModules.sheafificationAdjunction (𝟙 _)).homEquiv` to `pullbackValIso_comp h f M` and
unfold by those three naturality lemmas (the leading `PC.hom` falls out of `naturality_left`, the
trailing `forget(pbc).hom` out of `naturality_right`). ~20–40 LOC, no new mate calculus. (2) Then feed
the finished per-leg `cmp_leg` into the assembly via a **continuation lemma at default transparency**
(re-pin `(C := PresheafOfModules (W.presheaf ⋙ forget₂ CommRingCat RingCat))` on every `⊗ₘ`), and if
any slide still detonates, `set Pbh := Scheme.Modules.pullback h` to opaque-ify the exploding defeq
before `rw [scPb_slide …]`. First project file to touch: `PullbackTensorComp.lean` — add `cmp_leg`
(and `cmp_leg`-`N`) just below `pullbackValIso_comp` (L749), then the continuation lemma below `scPb_slide` (L770).

## Discarded
- Re-running `mateEquiv_vcomp`/`conjugateEquiv_comp` for `cmp_leg`: overlaps the in-file sheaf-side
  proof; analogue 1 (homEquiv-transpose) reuses that finished work instead of duplicating ~100 LOC.
- `simp`-unfolding `pullbackValIso` (directive's failed approach): loops; the homEquiv route keeps
  `pullbackValIso` folded and rewrites by naturality, not by unfolding.
- `slice_lhs`/`reassoc_of%` `rw` directly into the giant goal under relaxed transparency: same
  kabstract path that detonated in iter-320/321 — only safe once #1/#2 remove the relaxed-transparency
  defeq from kabstract's traversal.
