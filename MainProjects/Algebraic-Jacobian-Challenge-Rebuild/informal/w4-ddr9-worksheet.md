# W4-DDR9 WORKSHEET — the `divRepAff` / `divRep` assembly (spec-dd-r §3 item 8, Addendum-1 form)

*2026-07-19 (night), Fable design lane.  BINDING parents: `informal/spec-dd-r.md` §3
item 8 + Addendum 1 (the DivFamZar restatement), `informal/spec-w4-gates.md` (all
addenda; Addendum 2 is the scoreboard of record), `informal/w4-g5-worksheet.md` §3–§4.
Inbox absorbed: I-0222 (S6b co-sign), I-0228/I-0230 (G-1 + hdeg, unconditional),
I-0229 (G-3 Φ), I-0231/I-0235 (DDR-8 route correction + seam-free total mono),
I-0232 (G-2 + the orientation pin), I-0233/I-0234 (P-fib-N + the windowS seam),
I-0236 (G-5 files 1–4 + the reusable export layer), I-0193 (DDR-1 report — the
KeyChart gap).  Every file:line below was verified by DIRECT READ this pass; no lake,
no LSP (full rebuild running).  This worksheet pins the assembly so that Opus lanes
can write the files against it and G-4 slots in as a named interface.*

## §0 Verdicts up front

1. **Staged form (the §1 decision): affine-first homEquiv family, then a separate
   lift file to the spec-item-8 `Functor.RepresentableBy`.**  Both files are pinned
   here; neither re-derives the other's face.  Justification in §1.
2. **A brick nobody's scoreboard carries was found this pass: the carve discharge
   `divFamEps_carve` (DDR-9.0).**  Every landed consumer threads the carve `(♦)` of
   the ε-pair as a *hypothesis* `hcarve` (`Picard/DivSchemeClassifyAff.lean:91-94`,
   `RiemannRoch/CarveDegree.lean:183-187`, `Picard/DivisorFamilyEpsMono.lean:216`,
   w4-g5 §4's `divClassify`), and no theorem in the tree discharges it for an
   arbitrary certified family (grep over `Picard/`+`RiemannRoch/` this pass: all
   `carvePairArrow … = 0` conclusions are the universal-pair kill laws of
   `DivSchemeFamilyUniv.lean:106,:135` and the iff-transfers).  The backward
   direction of `divRepAff` classifies an ARBITRARY functor value, so without
   DDR-9.0 there is no Equiv.  It is honest new work, size M, launchable NOW
   (route in §2.0; the only genuinely new mathematics inside DDR-9's own scope).
3. **The forward direction is gated on G-4 AND on two pieces of DDR-1 tail plumbing
   that G-4 does not contain**: KeyChart (the chart value of `carveIdealSheaf` —
   still the "one DDR-1 gap" of I-0193, restated at `Picard/DivScheme.lean:31-35`)
   and the arbitrary-hom atlas factorization (no such lemma exists in the tree —
   grep over `Picard/DivCarve*`, `Picard/Grassmannian*` finds only the chart→locus
   direction `divScheme_exists_factor_of_le_ker`, `Picard/DivScheme.lean:161`).
   Both are pinned as named bricks (§3.2, §3.3) so they can run before G-4 lands.
4. **No Noetherian hypothesis anywhere in the assembly's own statements.**  The
   landed inputs are all Noetherian-free: G-2 (I-0232, `DivisorFamilyEpsNaturality.lean`
   variable block `:70-71`), the total mono (`DivSchemeMonoBridgeRel.lean:417`, any
   `CommRing R`), the frame cover (`DivSchemeFrameCover.lean:90` — `[CommRing R]`
   only), `divClassifyAff` (`DivSchemeClassifyAff.lean:62`).  The w4-g5 §4
   `[IsNoetherianRing S]` on `divClassify` is now droppable (it existed for the
   engine slots that I-0230 made unconditional) — **binding request to the G-5
   stitch lane: drop it**, else `divRep`'s homEquiv inherits a hypothesis the
   functor does not carry and the statement fails to typecheck as a
   `RepresentableBy`.  G-4's chart rings are Noetherian by instance
   (`DivSchemeFamilyUniv.lean:60-63`) — internal to G-4, never on the test.
5. **Instance seam, recorded once**: the classify tree runs at `[IsFinite π]`
   (`DivSchemeClassifyAff.lean:42`, `DivSchemeFrameCover.lean:65`), the Zar/functor
   tree at `[IsAffineHom π]` (`DivisorFamilyZarFunctor.lean:39`).  mathlib's
   `IsFinite extends IsAffineHom` (`Mathlib/AlgebraicGeometry/Morphisms/Finite.lean:39`),
   so the assembly context carries `[IsFinite π]` and instantiates `divFunctor`
   through the parent projection.  No transport lemma needed.

Standing context throughout (the `DivSchemeFrameCover.lean:64-82` pack, the largest
of the consumed blocks): `{k} [Field k]`, `C : Over (Spec (.of k))`, `π : C.left ⟶ P1 k`
`[IsFinite π]`, the curve instances, `hπ : π ≫ P1.structureMap k = C.left ↘ Spec (.of k)`,
`g r₁ r₂ : ℕ`, `hO : Sheaf.h0 (C.left.moduleKSheaf k) = 1`,
`hχ : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (g : ℤ)`, boundary bases
`b₁ : Basis (Fin r₁) k H_M`, `b₂ : Basis (Fin r₂) k H_{M+s}`.  Abbreviations:
`M := windowM_choice π hπ g`, `s := windowS_choice π hπ g`, `F̄ := fiberWeilDivisor π`,
`b₂' := b₂.map (windowShiftEquiv hπ g).symm`,
`DivScheme! := DivScheme k (s • F̄) (M • F̄) g r₁ r₂ b₁ b₂'` (`Picard/DivScheme.lean:144`),
`divSchemeι!`, `divSchemeOver!` (`:148`, `:156`), `ε := divFamEps hπ g`
(`Picard/DivisorFamilyWindow.lean:260-266`).

---

## §1 The statement

### §1.1 The final target (verbatim, stateable tonight)

The functor is landed and is the Addendum-1 vocabulary, consumed verbatim
(`Picard/DivisorFamilyZarFunctor.lean:45-47`):

```
noncomputable def divFunctor : (Over (Spec (.of k)))ᵒᵖ ⥤ Type u where
  obj T := divFamZar C π n T.unop
  map g := ↾divFamZar.map C π n g.unop
```

against mathlib's representability structure
(`.lake-packages/mathlib/Mathlib/CategoryTheory/Yoneda.lean:284-288`):

```
structure RepresentableBy (F : Cᵒᵖ ⥤ Type v) (Y : C) where
  homEquiv {X : C} : (X ⟶ Y) ≃ F.obj (op X)
  homEquiv_comp {X X' : C} (f : X ⟶ X') (g : X' ⟶ Y) :
    homEquiv (f ≫ g) = F.map f.op (homEquiv g)
```

So DDR-9 final =

```
divRep : (divFunctor C π g).RepresentableBy (divSchemeOver!)
```

Orientation fixed by mathlib: `homEquiv` maps hom → family, i.e. **the forward
direction is the pullback of the universal family**; `homEquiv.symm` is classify.
The Equiv laws are the two inverse laws: `homEquiv ∘ homEquiv.symm = id` on families
is **Law 1** (§4.1), `homEquiv.symm ∘ homEquiv = id` on homs is **Law 2** (§4.2);
`homEquiv_comp` is the naturality (§5).

### §1.2 The staged form — DECISION: affine-first homEquiv family (I-0222(B) shape), Zar-valued

```
noncomputable def divRepAff (S : Type u) [CommRing S] [Algebra k S] :
    (overSpec k S ⟶ divSchemeOver!) ≃ DivFamZar C S π g

theorem divRepAff_naturality {A B : Type u} [CommRing A] [Algebra k A]
    [CommRing B] [Algebra k B] (φ : A →ₐ[k] B) (v : overSpec k A ⟶ divSchemeOver!) :
    divRepAff B (Over.overSpecMap φ ≫ v) = DivFamZar.mapAlgHom φ (divRepAff A v)
```

— hom side on Over-homs at `overSpec k S` (so the §5 lift is uniform), family side
on the affine carrier `DivFamZar C S π g` (`Picard/DivisorFamilyZar.lean:235`), the
naturality in exactly the `divFamZarAffineEquiv_naturality` spelling
(`Picard/DivisorFamilyZarMap.lean:305-308`, with `Over.overSpecMap`
`Picard/RelPicAlgebra.lean:44`).

**Justification (the adjudication the parent asked for):**

1. *Where the mathematics closes is affine.*  Every landed consumable is
   algebra-native: `divClassifyAff` (`DivSchemeClassifyAff.lean:82`), the frame
   cover (`DivSchemeFrameCover.lean:456`), G-2 (`DivisorFamilyEpsNaturality.lean:441`),
   the total mono (`DivSchemeMonoBridgeRel.lean:417`), the universal pair
   (`DivSchemeFamilyUniv.lean:72-82`), the Zar glue/sep keystones
   (`DivisorFamilyZarGlue.lean:71`, `DivisorFamilyZarMapAlg.lean:240`).  The affine
   Equiv is the theorem; the general-test statement is transport.
2. *DD-2's landed general-test machinery makes the lift a bounded transcription, so
   staging loses nothing.*  I-0222's objection to (B) — "re-derives the general-test
   face" — is void now: `divFamZar` at general tests IS BY DEFINITION the compatible
   family of affine values (`DivisorFamilyZarVehicle.lean:187-190`), `divFamZar.map`
   along arbitrary test morphisms is landed with functor laws
   (`DivisorFamilyZarMap.lean:207`), and both sheaf halves are landed at arbitrary
   tests (`DivisorFamilyZarSheaf.lean:66`, `:237`).  §5's lift file consumes these
   as-is; the co-signed `divFunctor` is the statement vocabulary, not re-derived.
3. *Memory discipline.*  A direct `RepresentableBy` proof couples the Over category,
   `Scheme.Cover.glueMorphisms`, and the classify tree into single declarations —
   the exact profile that OOMed `DivSchemeClassify.lean` at 58 GB (spec-w4-gates
   `:16-19`).  The staged form puts one heavy declaration per compilation unit.
4. *The spec mandates it.*  spec-dd-r §4 ("the affine-level homEquiv is the
   mathematical content … land it first as `divRepAff`") and Addendum 1 item 4 —
   S6b landed does not retire the staging rule, only its trigger.

Degenerate note: `(overSpec k S ⟶ divSchemeOver!)` is a hom set in `Over (Spec k)`;
the scheme-level classify output (`divClassifyAff`'s `v : Spec (.of S) ⟶ DivScheme!`)
must be packaged with its structure triangle.  That triangle needs the small missing
lemma `pairChartMap_grPairStructMap` (I-0193 already names it; grep this pass: not
landed) — file plan row F2.

---

## §2 The backward direction (family → hom) = `divRepAff.symm`

### §2.0 DDR-9.0 — the carve discharge (NEW, launchable now)

```
theorem divFamEps_carve (G : CertifiedDivisorFamily C R π g)
    (a : ↥(divisorSections k (s • F̄) ⊤)) :
    Grassmannian.carvePairArrow (windowShiftMul hπ g a)
      (ε (DivFam.mk G)).1 (ε (DivFam.mk G)).2 = 0
```

(shape exactly the `hcarve` slot of `DivSchemeClassifyAff.lean:91-94`;
`windowShiftMul` `RiemannRoch/CarveDegree.lean:141-150`).  Route — membership, no
fibres, no rank arithmetic:

* `carvePairArrow μ K₁ K₂ = mkQ ∘ (μ ⊗ R) ∘ incl` vanishes iff `(windowShiftMul a)`'s
  base change maps `ε₁` into `ε₂`; unfold `ε` via `divFamEps_mk`
  (`DivisorFamilyWindow.lean:269-273`) and membership via `mem_divisorWindow_iff`
  (`:111-118`): `x ∈ K_a(d)` iff `relThetaWindowEquiv x` lies in
  `d.vanishingSubmodule` — chart-componentwise germ-in-stalk-ideal
  (`Picard/DivisorStalkIdeal.lean:215-238`).
* The stalk ideal absorbs multiplication (`Ideal.mul_mem_left` — already the
  mechanism of `vanishingSubmodule.smul_mem'`, `DivisorStalkIdeal.lean:232-238`).
  So the ONLY content is the **cross-exponent multiplicativity of the window
  identification**: `relThetaWindowEquiv (M+s) ((sectionMulBilin a).baseChange x)` is
  the componentwise product of the `Θ^s`-image of `a` with
  `relThetaWindowEquiv M x`, the cocycle law being
  `relThetaCocycle (M+s) = relThetaCocycle s * relThetaCocycle M` — which is
  `pow_add` through `relUnitCocycle (thetaUnit π ^ n)`
  (`Cohomology/RelThetaTwist.lean:58-62`).  This is the RELATIVE avatar of
  I-0229's one residual (Φ-pack multiplicativity, field-level); state it on pure
  tensors `1 ⊗ₜ m` and extend linearly, per the I-0232 crux-triangle pattern.
* New file `Picard/DivSchemeEpsCarve.lean`; keystones `relThetaWindowEquiv_sectionMul`
  (the compat) + `divFamEps_carve`.  Consumed by: backward (here), and by nothing
  else — Law 1/Law 2 get their carve from the universal side (§3.4).

### §2.1 The composition (per certified piece)

Input: `F₀ : DivFamZar C S π g`.  Steps, all names landed unless flagged:

1. **Local certificates.**  `Quotient.exists_rep` + the `IsLocallyCertified` carrier
   (the pattern of `DivFamZar.exists_glue_of_away_compat`'s own proof,
   `DivisorFamilyZarGlue.lean:86-99`): a finite span-⊤ family `h : ι → S` with
   certified representatives `G_l : CertifiedDivisorFamily C (Away (h l)) π g` and
   `DivFam.toZar`-classes restricting `F₀`.
2. **Per-piece frame cover.**  For each `l`, `divFamEps_exists_frameCover`
   (`DivSchemeFrameCover.lean:456-468`, verbatim):

   ```
   theorem divFamEps_exists_frameCover (F : DivFam C S π g) :
       ∃ (m : ℕ) (f : Fin m → S), Ideal.span (Set.range f) = ⊤ ∧
         ∀ t : Fin m, ∃ i j (w : PairChartRing k g r₁ g r₂ i j →ₐ[k] Localization.Away (f t)),
           (Module.Grassmannian.map w (pairTautFst k g r₁ r₂ i j)).toSubmodule
             = Submodule.map (LinearMap.baseChange (Localization.Away (f t)) b₁.equivFun.toLinearMap)
                 (divFamEps hπ g (DivFam.mapAlg (Localization.Away (f t)) g F)).1 ∧ (…Snd/b₂…)
   ```

   — the `hw₁/hw₂` inputs of `divClassifyAff` at each piece, ALREADY in final shape
   (I-0236: "verified by an end-to-end consumption stub — `divClassifyAff` fires
   verbatim").
3. **Per-piece classify.**  `divClassifyAff` (`DivSchemeClassifyAff.lean:82-102`):
   with `hw₁`, `hw₂` from step 2 and `hcarve` from DDR-9.0 transported along
   `Away (h l) → Away (h l · f t)` (the `hcarve_mapAlg` chain of w4-g5 §2 bottom:
   `baseChange_carvePairArrow_eq_zero_iff` `Picard/DivCarveKit.lean:190` `.mp` +
   the G-2 rewrite through `DivFam.window_mapAlg` — G-5 file 5's one remaining
   obligation, I-0236), get per piece
   `∃! vₜ, vₜ ≫ divSchemeι! = Spec.map (CommRingCat.ofHom w.toRingHom) ≫ pairChartMap …`.
4. **Overlap agreement (W3) — what EXACTLY remains.**  The `glueMorphisms`
   obligation `pullback.fst (𝒰.f t) (𝒰.f t') ≫ vₜ = pullback.snd … ≫ v_{t'}` over
   the composite cover `{h l · f t}`.  Landed: the reduction to `divSchemeι!`
   composites (`divScheme_hom_ext`, `Picard/DivScheme.lean:172-175`), the
   `pullbackSpecIso` conjugation into an abstract overlap ring `B` (pattern
   `Picard/GrassmannianPair.lean:73-79`), and W2 over `B`
   (`Picard/GrassmannianPairCompare.lean:120-130`, verbatim):

   ```
   theorem specMap_pairChartMap_eq_of_map_pairTaut_eq
       (i i' : (glueData k g r₁).J) (j j' : (glueData k g r₂).J) {B : Type u} [CommRing B]
       [Algebra k B] (w : PairChartRing k g r₁ g r₂ i j →ₐ[k] B)
       (w' : PairChartRing k g r₁ g r₂ i' j' →ₐ[k] B)
       (h₁ : Module.Grassmannian.map w (pairTautFst k g r₁ r₂ i j)
           = Module.Grassmannian.map w' (pairTautFst k g r₁ r₂ i' j'))
       (h₂ : … pairTautSnd …) :
       Spec.map (CommRingCat.ofHom w.toRingHom) ≫ pairChartMap k g r₁ g r₂ i j
         = Spec.map (CommRingCat.ofHom w'.toRingHom) ≫ pairChartMap k g r₁ g r₂ i' j'
   ```

   with W1 beneath it (`Picard/GrassmannianChartCompare.lean:93-99`).  **The missing
   W3 lemma, in landed vocabulary**: W2's inputs `h₁/h₂` over `B`, i.e.

   *the two pushed framings present the same point*:
   `Module.Grassmannian.map (leg_B ∘ wₜ) (pairTautFst iₜ jₜ)
      = Module.Grassmannian.map (leg'_B ∘ w_{t'}) (pairTautFst i_{t'} j_{t'})`,

   proven by pushing each piece's `hw₁` equality of submodules along the two legs
   `Away (f t) →ₐ[k] B ←ₐ[k] Away (f t')` and identifying both right-hand sides with
   the coordinate image of `ε (DivFam.mapAlg B g F)`.  G-5 file-4's export layer
   already gives the whole right-hand side: `DivFam.window_mapAlg` at ANY ledger
   window over a GENERIC base (`DivSchemeFrameCover.lean:132-137` — I-0236: "the
   exact shape W3/§4's double-overlap legs need"), `map_divFamWindowGr` for tower
   legs (`:188-220`), `DivFam.mapAlg_comp` (`Picard/DivisorFamilyMapAlg.lean:349`),
   and G-2 both legs (`divFamEps_mapAlg`, `DivisorFamilyEpsNaturality.lean:441-447`
   — instance form, NO hypotheses on `B`).  What file 4 does NOT give and W3 must
   add: the left-leg pushforward computation (`Submodule.map_map` +
   `windowBaseChange` functoriality along a composite, the K4/`map_congrAmbient`
   pattern) — one lemma, ~80–120 L inside G-5 file 6.  Nothing else remains of W3.
5. **Stitch.**  `𝒰.glueMorphisms (vₜ) hglue` + `ι_glueMorphisms` + `Cover.hom_ext`
   (mathlib `Gluing.lean:439-462`; in-repo precedent `Picard/Pic0SigmaSheaf.lean:97-105`)
   — w4-g5 §3.3 verbatim, then the w4-g5 §4 `divClassify` ∃!-form (minus its
   Noetherian hypothesis, §0.4).
6. **Uniqueness / well-definedness across all choices** (representative `G_l`,
   certificate cover, frame cover): any two candidate morphisms agree piecewise by
   `divScheme_hom_ext` + W2 (their `divSchemeι!`-composites frame the same ε-point)
   and globally by `Scheme.Cover.hom_ext`; on the family side the classes agree by
   `DivFamZar.eq_of_away_eq` (`Picard/DivisorFamilyZarMapAlg.lean:240-246`,
   verbatim):

   ```
   theorem DivFamZar.eq_of_away_eq {n : ℕ} {ι : Type u} [Finite ι] (g : ι → R) (S : ι → Type u)
       … [∀ i, IsLocalization.Away (g i) (S i)] (hg : Ideal.span (Set.range g) = ⊤)
       {F G : DivFamZar C R π n} (h : ∀ i, DivFamZar.mapAlg (S i) n F = DivFamZar.mapAlg (S i) n G) :
       F = G
   ```

Backward is gated on: DDR-9.0 + G-5 files 5–6.  It does NOT touch G-4.

---

## §3 The forward direction (hom → family) = `divRepAff` applied

**HONEST STATUS: gated on G-4 (`DivSchemeEpsUniv` — does not exist; scoreboard row
"G-4 seed/cert/EpsUniv: pending, gated on windowS strengthening" I-0234), plus two
DDR-1-tail bricks (§3.2, §3.3) that no G-lane owns.**  What stands tonight in
`Picard/DivSchemeFamilyUniv.lean`: the universal PAIR only —
`DivCarveChartRing` (`:55`), `divCarveChartMk` (`:66`),
`divUniversalFst/Snd := Module.Grassmannian.map (divCarveChartMk …) (pairTautFst/Snd …)`
(`:72-82`), the kill law (`:86`), `divUniversal_carve` (`:106-120`) and
`divUniversal_carve_residueField` (`:135-147`).  No seed, no certificate, no ε
identity.  The DDR-5 receptacle is landed and waiting
(`Picard/DivSchemeEps.lean:309-330`, `ThetaGeneratorSeed.divFamEps_certifiedFamily`,
threading `hsurj₁/hsurj₂/hle₂`; its unconditional-ingredients form
`divFamEps_mk_eq_of_le` at `:279-297`), as is the whole seed layer
(`ThetaGeneratorSeed` `Picard/DivSchemeFamily.lean:74`, `IsGenerator` `:129`,
`localEquations`/`divisorAdaptation` `:349,:367`, `certifiedFamily`
`Picard/DivSchemeEps.lean:234`, `isGenerator_of_fibre_ne_zero`
`Picard/DivSchemeSeed.lean:188`).

### §3.1 THE G-4 INTERFACE BLOCK (named: **DDR9-U** — the assembly is written against exactly this; G-4 slots in)

For every pair chart `(i, j)`, at the campaign instantiation
(`A := s • F̄`, `B := M • F̄`, bases `b₁`, `b₂'`), writing
`R_Z := DivCarveChartRing k (s•F̄) (M•F̄) g r₁ r₂ b₁ b₂' i j`:

* **U1 (the family).**
  `divUniversalFamily i j : CertifiedDivisorFamily C R_Z π g`.
* **U2 (the ε-identity, in `divClassifyAff`'s hw-shape — pinned so it slots into
  §2 step 3 and §4 with ZERO conversion).**  `divClassifyAff`'s `hw₁`/`hw₂`
  (`DivSchemeClassifyAff.lean:85-90`) hold at
  `(S := R_Z, w := divCarveChartMk k (s•F̄) (M•F̄) g r₁ r₂ b₁ b₂' i j,
  F := DivFam.mk (divUniversalFamily i j))`:

  ```
  U2 : (Module.Grassmannian.map (divCarveChartMk …) (pairTautFst k g r₁ r₂ i j)).toSubmodule
         = Submodule.map (LinearMap.baseChange R_Z b₁.equivFun.toLinearMap)
             (divFamEps hπ g (DivFam.mk (divUniversalFamily i j))).1     (and Snd/b₂ mirror)
  ```

  Note the left side IS `(divUniversalFst i j).toSubmodule` definitionally
  (`DivSchemeFamilyUniv.lean:72-75`).
* **U3 (carve at the universal point) — DERIVABLE, not a new G-4 obligation**:
  `hcarve` for `DivFam.mk (divUniversalFamily i j)` follows from landed pieces once
  U2 stands: `divUniversal_carve` at `S := R_Z` (`FamilyUniv:106`) gives the carve
  on the `ker (baseChangeMkQ)` pair; `carvePairArrow_divCarveMul_eq_zero_iff`
  (`Picard/DivSchemeClassifyBridgeIff.lean`, the DDR-6 §3a′ keystone) converts
  `divCarveMul` coordinates to the `windowShiftMul` spelling; U2 +
  `Module.Grassmannian.map_toSubmodule` rewrites the pair as the coordinate image
  of ε.  (So DDR-9.0 is NOT needed on the forward/universal side.)
* G-4-internal (behind the interface, per spec-w4-gates Addendum 1 G-4): the seed
  from fibrewise P-fib-N (`existsUnique_effective_divisor_of_carve_pack`,
  `RiemannRoch/PFibPack.lean`, I-0233, fed by `divUniversal_carve_residueField`),
  the certificate discharge, DDR-5's `hle₂`.  None of these names crosses the
  interface.
  **CORRECTION 2026-07-26 (run 0048 round 2).**  This bullet used to end "all gated on
  the I-0234 windowS strengthening (b+2g → b+3g) and its full-rebuild window".  THAT
  STRENGTHENING IS DONE: `windowS_choice` satisfies `windowS_spec_three : windowBound +
  3g ≤ (s−1)·δ` (`RiemannRoch/WindowLedger.lean:157`; `windowS_spec` is kept at 2g only
  for byte compatibility with pre-I-0234 consumers), and I-0234 is archived.  The lane
  quoted this discharged blocker as live for several rounds.  What U2 is *actually*
  gated on is the certificate discharge — `ThetaGeneratorSeed.certifiedFamily`
  (`Picard/DivSchemeEps.lean:237`) demands a global `IsCertified` over the chart ring —
  i.e. mountain 1.  The seed itself exists (`Picard/DivSchemeSeedUnivGen.lean:283`) and
  the fibrewise keystone is proved
  (`existsUnique_effective_divisor_divUniversalFibre`,
  `Picard/DivSchemeSeedUnivAssembleKappa.lean:417`, `:481`).

### §3.2 DDR-9.F0 — KeyChart + Over packaging (NEW, launchable now)

I-0193's "one DDR-1 gap", verbatim target: `carveIdealSheaf.ideal (pair-chart open
i j) = comap of divCarveIdeal i j along the chart Γ-iso`, at the campaign multiplier.
Landed halves it composes: `carveIdealSheaf := ⨅ (carveLocusToGrPair …).ker`
(`Picard/DivScheme.lean:55-58`), the gluing compatibility
`carveIdeal_le_ker_of_specMap_pairChartMap_eq` (`Picard/DivCarveLocus.lean:190`),
`ker_carveSchemeι` (`DivScheme.lean:71-74`), and the kernel half
`carveIdealSheaf_le_ker_of_factors` (`:114-119`).  Route as written in I-0193
(sheaf-section ext + basic opens + `IsOpenImmersion.lift` + Spec.preimage; hazards
list there is binding).  Same file: `pairChartMap_grPairStructMap`
(`pairChartMap ≫ grPairStructMap = Spec.map (algebraMap k R_{I,J})`-form, from
`pairChartMap_fst` `Picard/DivCarvePairChart.lean:176` + `ι_grStructMap`) and the
Over-triangle corollary: every `v` with `v ≫ divSchemeι! = Spec.map w ≫ pairChartMap`
on a cover is a morphism `overSpec k S ⟶ divSchemeOver!` — the §1.2 hom-set
packaging.

### §3.3 DDR-9.F1 — the atlas factorization (NEW; gated on F0 only)

```
theorem divScheme_exists_chartFactor (S) [CommRing S] [Algebra k S]
    (v : overSpec k S ⟶ divSchemeOver!) :
    ∃ (m : ℕ) (f : Fin m → S), Ideal.span (Set.range f) = ⊤ ∧
      ∀ t, ∃ i j (ω : DivCarveChartRing … i j →ₐ[k] Localization.Away (f t)),
        Spec.map (CommRingCat.ofHom ω.toRingHom) ≫ divCarveChartToDivScheme i j
          = Spec.map (CommRingCat.ofHom (algebraMap S (Localization.Away (f t)))) ≫ v.left
```

where `divCarveChartToDivScheme i j : Spec (.of R_Z) ⟶ DivScheme!` is the factor of
`Spec.map divCarveChartMk ≫ pairChartMap` through `divSchemeι!` given by
`divScheme_exists_factor_of_le_ker` (`DivScheme.lean:161-168`) at
`hker := Ideal.Quotient` kill (`divCarveIdeal_le_ker_of_tower`, `FamilyUniv:86`) —
definable TONIGHT, before G-4.  Proof route: `u := v.left ≫ divSchemeι!` into
`grPair`; pull back `grPairCover` (`Picard/GrassmannianPair.lean:62-65`, finite
`:68`) and conjugate pieces by `grPairPatchIso` (`:73-79`); refine by basic opens of
`Spec S`; Γ–Spec extracts `w_t : PairChartRing i j →ₐ[k] Away (f t)` (over-`k` via
`pairChartMap_grPairStructMap`, F0); `w_t` kills `divCarveIdeal i j` by
`carveIdealSheaf_le_ker_of_factors` + **KeyChart** (F0) — descend through
`Ideal.Quotient.liftₐ` to `ω`.  This is the GRQ hom-side pattern
(`grPointOfRankQuotient` uniqueness legs, GRQ `:4999-5109`, route map only).

### §3.4 The forward composite (needs G-4)

Per factorization piece `t` of §3.3: `Gₜ := (divUniversalFamily iₜ jₜ).mapAlg (Away (f t)) g`
along `ωₜ.toAlgebra` (`CertifiedDivisorFamily.mapAlg`,
`Picard/DivisorFamilyMapAlg.lean:266-270`; instance form `:158-160`, the recorded
`Grassmannian.map` seam discipline of `FamilyUniv:104-105`); `toZar` each
(`DivFam.toZar`, `Picard/DivisorFamilyZar.lean:272-276`); glue by
`DivFamZar.exists_glue_of_away_compat` (`DivisorFamilyZarGlue.lean:71-85`).  The
overlap compatibility `hcompat i j` is the FAMILY-side W3: on
`T i j := Away (f t · f t')` both restricted families have equal ε — U2 pushed
through G-2 (`divFamEps_mapAlg`) along both legs + `DivFam.mapAlg_comp` — so
`divFam_divEq_of_eps_eq_total` (`Picard/DivSchemeMonoBridgeRel.lean:417-423`,
verbatim):

```
theorem divFam_divEq_of_eps_eq_total (g : ℕ) (G G' : CertifiedDivisorFamily C R π g)
    (heps : divFamEps hπ g (DivFam.mk G) = divFamEps hπ g (DivFam.mk G'))
    (hOk : Sheaf.h0 (C.left.moduleKSheaf k) = 1)
    (hχk : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (g : ℤ)) :
    DivFam.mk G = DivFam.mk G'
```

closes it (`toZar` respects: `DivFam.toZar_mapAlg`,
`DivisorFamilyZarMapAlg.lean:204-207`).  Choice-independence of the factorization:
same argument + `DivFamZar.eq_of_away_eq` on a common refinement.

---

## §4 The two laws

### §4.1 Law 1 — `divRepAff (divRepAff.symm F₀) = F₀` (family side)

Chain, per piece of the composite cover (certificate cover × frame cover × the
classify factorization), all at `T := Away (·)`:

1. `divRepAff.symm F₀ =: v` satisfies per piece
   `Spec.map (algebraMap) ≫ v.left ≫ divSchemeι! = Spec.map wₜ ≫ pairChartMap iₜ jₜ`
   (§2 step 3's ∃! clause).
2. Forward of `v` restricted to the piece = `toZar` of
   `DivFam.mapAlg T g (DivFam.mk (divUniversalFamily iₜ jₜ))` (§3.4; the §3.3
   factorization can be taken through the SAME `wₜ` by ∃!-stability under
   refinement, w4-g5 §4's "clause stable under further localization").
3. `ε` of that family: `divFamEps_mapAlg` (G-2, `EpsNaturality:441-447`) —
   `ε (DivFam.mapAlg T g ·) = (windowBaseChange T ε₁, windowBaseChange T ε₂)` — then
   **U2** rewrites `ε (DivFam.mk (divUniversalFamily))` as the (inverse) coordinate
   image of the universal taut pair; `windowBaseChange` converts to the
   `Module.Grassmannian.map` kernel spelling with NO transport
   (`windowBaseChange_eq_ker_baseChangeMkQ`, `EpsNaturality:116-120` — the I-0232
   orientation pin, definitional against `ker_baseChangeMkQ_eq_map_baseChange`,
   `Picard/DivCarveKit.lean:168`).
4. Step 1's clause + step 3: the pulled taut pair equals the coordinate image of
   `ε (DivFam.mapAlg T g F)` for (a representative of) the input `F₀` — this is
   `hw₁ₜ/hw₂ₜ` of the frame cover (§2 step 2) read back.  Coordinates removed by
   the base-changed `b.equivFun` equivalences (injective;
   `Submodule.map`-cancellation along a `LinearEquiv`), giving
   `ε (pulled universal) = ε (restricted F)`.
5. `divFam_divEq_of_eps_eq_total` (DDR-8, `MonoBridgeRel:417`) — equality in
   `DivFam` per piece; `DivFam.toZar_mapAlg` (`ZarMapAlg:204`) moves it to the Zar
   classes.
6. `DivFamZar.eq_of_away_eq` (`ZarMapAlg:240`) over the composite span-⊤ family:
   forward(backward(F₀)) = F₀.

Consumed: G-2 + U2 (G-4) + DDR-5's receptacle (inside G-4's discharge of U2) +
DDR-8 total + DD-2 separation.  Exactly the spec chain "Law 1 =
`DivSchemeEpsUniv` + G-2 + DDR-8" (spec-w4-gates `:228`), with the ε-projection
identities of `Picard/DivSchemeEps.lean:279-330` living inside U2's proof, not here.

### §4.2 Law 2 — `divRepAff.symm (divRepAff v) = v` (hom side, chart-local hom-ext)

1. Forward of `v` is glued from `mapAlg`s of universal families through the §3.3
   pieces (`f_t`, `ωₜ`, hence `wₜ := ωₜ.comp (divCarveChartMk …)`… precisely:
   `wₜ` kills `I_♦` and factors as chart data).
2. Backward of that family classifies per piece; by U2 + G-2 (step 3-4 of §4.1 run
   forward) the restricted family's ε is framed by the SAME `wₜ` — so `v` itself
   satisfies the per-piece ∃! characterization
   (`Spec.map (algebraMap) ≫ v.left ≫ divSchemeι! = Spec.map wₜ ≫ pairChartMap`,
   from §3.3's factorization + `divCarveChartToDivScheme ≫ divSchemeι! =
   Spec.map divCarveChartMk ≫ pairChartMap` by construction).
3. Uniqueness of the classify output per piece (`divClassifyAff`'s ∃!,
   `ClassifyAff:95-102`) + `divScheme_hom_ext` (`DivScheme:172-175`) force
   piecewise agreement; `Scheme.Cover.hom_ext` (mathlib `Gluing.lean:451`) globalizes;
   the Over-hom equality reduces to `.left` (Over-hom ext, `CommaMorphism.ext`).

Consumed: U2 + G-2 + W2 + hom-ext.  No mono, no DDR-9.0.

### §4.3 Affine naturality (`divRepAff_naturality`)

Forward form: `divRepAff B (overSpecMap φ ≫ v) = DivFamZar.mapAlgHom φ (divRepAff A v)`.
Both sides are Zar-glues of pulled universal families; compare on a common
refinement of the two factorizations (φ-image of A's cover × B's own):
`DivFam.mapAlg_comp` / `DivFamZar.mapAlg_comp` (`ZarMapAlg:222-228`) +
`DivFamZar.eq_of_away_eq`.  ~100 L, mechanical once §3.4 is phrased through a
`divRepPullAt (f_t, ωₜ)` helper with a characterizing lemma (do this — do not prove
naturality against the raw `Classical.choose`).

---

## §5 The `divRep` lift (affine → general tests)

New file `Picard/DivRep.lean`.  Content, exactly:

1. **homEquiv, componentwise** (no universal element over `DivScheme!` is
   constructed — that variant would need a Zar-glue over the non-affine
   `divSchemeOver!` itself; rejected for weight): for `T : Over (Spec (.of k))`,

   ```
   homEquiv (u : T ⟶ divSchemeOver!) : divFamZar C π g T :=
     ⟨fun U : T.left.affineOpens =>
        divFamZarAffineEquiv … (divRepAff Γ(T.left, U.1) (restrictAff U u)) …, compat⟩
   ```

   where `restrictAff U u : overSpec k Γ(T.left, U.1) ⟶ divSchemeOver!` is the
   affine-open restriction (the `U.2.isoSpec`-conjugated inclusion composed with
   `u` — one small Over-plumbing def, the only new geometry in the file), and
   `compat` is `divRepAff_naturality` at `Over.resAlgHom T h`
   (`DivisorFamilyZarVehicle.lean:188-190`'s subtype condition, verbatim).
   Vocabulary check: the vehicle value at `U` is `DivFamZar C Γ(T.left, U.1) π g`
   — `divRepAff`'s codomain on the nose; `divFamZarAffineEquiv`
   (`Vehicle:300`) is NOT needed here (only in the affine-comparison lemma below).
2. **homEquiv.symm**: given `s : divFamZar C π g T`, classify per affine open
   (`divRepAff.symm (s.1 U)`), glue the `.left` morphisms over `T.left.affineCover`
   by `Scheme.Cover.glueMorphisms` — overlap agreement from
   `divRepAff_naturality` + `s.compat` + `divScheme_hom_ext` on affine
   sub-opens, separation to arbitrary overlaps by `ext_of_le_cover`'s own
   basic-open technique (`DivisorFamilyZarSheaf.lean:66-81` — reuse
   `Scheme.exists_basic_subcover`, `:72`); the Over-triangle from F0's packaging.
3. **Inverse laws at T**: reduce affine-open-wise — family side by the vehicle's
   `ext` (`Vehicle:202-205`) + Law 1; hom side by `Scheme.Cover.hom_ext` + Law 2.
4. **homEquiv_comp**: for `f : T' ⟶ T`, both sides are sections of
   `divFamZar C π g T'`; apply `ext_of_le_cover` (`ZarSheaf:66`) over the cover of
   `T'.left` by preimages of affine opens refined to affine sub-opens, where
   `divFamZar.map`'s no-gluing evaluation `mapVal_eq_mapAlgHom`
   (`DivisorFamilyZarMap.lean` header list) turns the right side into
   `DivFamZar.mapAlgHom` of an affine value, and the left side is
   `divRepAff_naturality` at the section-ring algebra map — i.e. `homEquiv_comp`
   is exactly `divFamZarAffineEquiv_naturality`'s (`ZarMap:305-308`) proof shape
   lifted through `divRepAff_naturality`.  `existsUnique_glue_of_le_cover`
   (`ZarSheaf:237-239`) is available if step 2's glued section needs its
   characterizing property rather than a direct construction.
5. **Package**: `divRep : (divFunctor C π g).RepresentableBy (divSchemeOver!)`
   (`divFunctor_obj/map` simp lemmas `ZarFunctor:56-65` close the `F.map`
   normal forms), plus the two computation lemmas the spec item 8 asks:
   `divRep_homEquiv_apply` at affine tests through `divFamZarAffineEquiv`
   (`Vehicle:300`) and `divRep_homEquiv_symm_apply` through `divRepAff.symm`.

---

## §6 File plan, sizes, lane order, gating

Memory discipline (spec-w4-gates `:16-19`, `:153-158`, Addendum 2 lane notes):
ONE heavy lane at a time; single-module `lake build` with `LEAN_NUM_THREADS=1`;
`set_option maxSynthPendingDepth 3` in-file; ≤ 500 L; one heavy declaration per
compilation unit; the I-0230/I-0232/I-0235/I-0236 gotcha lists are REQUIRED READING
before writing any heavy proof here (set-poisoning, semireducible rw targets,
`include … in`, named-def unification, term-mode over rw on glueData composites).

| # | file (new) | contents | size | gated by | launchable before G-4? |
|---|---|---|---|---|---|
| F1 | `Picard/DivSchemeEpsCarve.lean` | DDR-9.0: `relThetaWindowEquiv_sectionMul` + `divFamEps_carve` (§2.0) | M | none (landed W-layer + RelThetaTwist) | **YES — now** |
| F2 | `Picard/DivSchemeKeyChart.lean` | KeyChart (I-0193 route) + `pairChartMap_grPairStructMap` + Over-hom packaging (§3.2) | M→L | none | **YES — now** |
| F3 | `Picard/DivSchemeAtlasFactor.lean` | `divCarveChartToDivScheme` + `divScheme_exists_chartFactor` (§3.3) | M | F2 | **YES** |
| G5 | `Picard/DivSchemeClassifyLocal/Global.lean` | files 5–6 of w4-g5 (per-piece `vₜ`, `hcarve_mapAlg`, W3 §2.4, `divClassify` — **Noetherian-free**, §0.4) | M→L + L | G-5 lane owns; W3 residual pinned §2.4 | **YES** |
| F4 | `Picard/DivRepClassifyZar.lean` | backward at the Zar layer (§2.1 steps 1,3,5,6 over the certificate cover) | M→L | F1 + G5 | **YES** |
| F5 | `Picard/DivRepPull.lean` | forward `divRepPullAt` + the glued forward map + choice-independence (§3.4) | M | **G-4 (DDR9-U)** + F3 | no |
| F6 | `Picard/DivRepAff.lean` | `divRepAff` Equiv + Law 1 + Law 2 + `divRepAff_naturality` (§4) | L (split Law 1 out if > 450 L) | F4 + F5 (hence G-4) | no |
| F7 | `Picard/DivRep.lean` | the lift + `divRep` + computation lemmas (§5) | M→L | F6 | no |

Lane order under the memory constraint: F1 ∥ F2 (light, disjoint imports) → F3 →
[G-4 lands: DDR9-U] → F5 → F6 → F7, with G5 → F4 running in the gaps (G5 is the
other lane's queue; F4 is ours once G5 lands).  Four of eight rows are launchable
before G-4 — the assembly need not idle on the windowS rebuild window.

**Honest risks.**

1. **DDR-9.0's multiplicativity seam (medium — the assembly's only new
   mathematics).**  The cross-exponent compat of `relThetaWindowEquiv` with
   `sectionMulBilin` has no landed precedent; its field shadow is exactly I-0229's
   one residual, and the I-0232 crux triangle shows this class of statement is
   provable but elaboration-hostile.  Mitigation: pure-tensor statement, chart
   componentwise, `pow_add` cocycle law; if it walls, the fallback is to state
   `divRepAff` on the carve-subfunctor and add the carve to `IsLocallyCertified` —
   a DD-2 vocabulary change requiring an orchestrator decision (record BEFORE
   taking it; it moves the DD-2 freeze).
2. **G-4 slippage (high impact, externalized).**  L→XL, spec-dd-r §7 risk 1, plus
   the I-0234 ledger rebuild.  The DDR9-U interface (§3.1) is the insulation: F5/F6
   are written against U1/U2/U3 names only; a G-4 spelling shift moves one file.
3. **KeyChart bookkeeping (medium).**  I-0193's route is written but is sheaf-level
   plumbing with the recorded ULift/motive hazards; nobody has attempted it since
   07-16.  Mitigation: it is pure DDR-1 vocabulary (no curve, no window), so it can
   be delegated cold from I-0193 + this §3.2.
4. **Elaboration weight of F6/F7 (medium).**  Full curve context + Over + covers +
   classify tree is the 58 GB profile.  Mitigations: the F4/F5/F6 split above keeps
   each Equiv half in its own unit; `divRepPullAt` characterizing-lemma style (§4.3)
   avoids `Classical.choose` unfolding in laws; heavy decls get the I-0198 escape
   hatch pattern only in-file.
5. **∃!-clause stability / choice-independence (low-medium).**  Both backward and
   forward glue over CHOSEN covers; every comparison must run through
   `eq_of_away_eq`/`hom_ext` on refinements — the w4-g5 §4 arbitrary-`f₀` pattern
   (~100 L each place).  Budgeted in F4/F5 sizes.
6. **Scope guard.**  NOT needed anywhere in DDR-9 (recorded to prevent creep): the
   glued `grPoint` (spec-dd-r §2 verdict stands), `Presieve.IsSheaf` packaging
   (I-0222(C) rejected), any `hsurj/hfib/hdeg` threading (all unconditional since
   I-0230), support-separation hypotheses (spec-dd-r Discipline 2), Noetherian
   hypotheses on tests (§0.4), fibrewise-implies-relative shortcuts (I-0231's
   counterexample is binding — Law 1 goes through ε-equality + the total mono,
   never through fibres).

*End of worksheet.  The §0.2 (DDR-9.0) and §0.3 (KeyChart/atlas-factor) findings
and the §0.4 Noetherian request to the G-5 stitch lane should be echoed to the
orchestrator; DDR9-U (§3.1) is the coordination handle with the G-4 lane — U2's
hw-shape is frozen by this worksheet pending G-4 sign-off.*
