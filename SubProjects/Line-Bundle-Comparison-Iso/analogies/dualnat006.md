# Analogy: naturality of a sectionwise transport `legA ≫ inv ε` over a thin poset

## Mode
cross-domain-inspiration

## Slug
dualnat006

## Iteration
006

## Structural problem (abstracted)
A family of morphisms `T_V : A(V) ⟶ B(V)` indexed by a thin poset, each `T_V = legA_V ≫ (inv ε)_V`,
must satisfy a naturality square for every `g : V ⟶ W`. Leg-B = `inv ε`, where `ε` is the
lax-monoidal unit comparison of a change-of-base functor (`restrictScalars`). The pointwise
reduction (`ext z; simp [ε-as-ringmap]`) times out at `whnf` because it forces the deep `inv ε`
composite through `whnf` on every section element. We want naturality WITHOUT that reduction.

## Failed approaches (from directive)
- `ext z; simp [pushforward/restrictScalars]; exact (φ.naturality …) z`: whnf heartbeat timeout.
- `subsingleton` on the OUTER isoMk square: only valid for dual-valued (unit-target) codomain.
- hand-pasting the four legs through the restriction `.map` via `erw`: never assembles.

## Analogues found

### Analogue: `CategoryTheory.IsIso.inv_comp_eq` + `CategoryTheory.CommSq.horiz_inv`
- **Domain**: category theory (general iso calculus). `Mathlib.CategoryTheory.Iso`,
  `Mathlib.CategoryTheory.CommSq`.
- **Same structural problem there**: a commuting square one of whose edges is an isomorphism's
  INVERSE. `CommSq.horiz_inv`: `CommSq f.hom g h i.hom → CommSq f.inv h g i.inv` — a square with
  iso horizontal edges stays commuting when both are inverted (and flipped). `IsIso.inv_comp_eq`:
  `inv α ≫ f = g ↔ f = α ≫ g`.
- **Technique**: never apply `inv ε` to an element. Rotate the `inv ε` edge across the equation /
  invert the whole square so the goal becomes the FORWARD `ε` square. The forward square is plain
  `ε`-naturality, closed by a coherence lemma. Entirely morphism-level — no `ext z`, no
  `dualUnitRingSwap_apply`, so `whnf` is never invoked on `inv ε`.
- **Mapping to project**: in `sliceDualTransport.naturality` (DualInverse.lean:547-556) and
  `sliceDualTransportInv.naturality` (DualInverse.lean:398-410), `dualUnitRingSwap = inv (ε …)` is
  the iso edge. Replace `ext z; simp only [..., dualUnitRingSwap_apply]` with
  `apply PresheafOfModules.hom_ext` then `rw [IsIso.inv_comp_eq]` (or `CommSq.horiz_inv` on the
  pre-built forward square), turning the goal into the forward-`ε` naturality square that
  `φ.naturality i.op` (already `hφ`) feeds.
- **Porting cost**: LOW. No new infra; `isIso_ε_restrictScalars_appIso` already gives the `IsIso`.
- **Verdict**: ANALOGUE_FOUND.

### Analogue: `CategoryTheory.NatTrans.IsMonoidal.unit` (`.unit_assoc`)
- **Domain**: monoidal category theory. `Mathlib.CategoryTheory.Monoidal.NaturalTransformation`.
- **Same structural problem there**: for a monoidal natural transformation `τ : F₁ ⟶ F₂` between
  lax-monoidal functors, the unit axiom `ε F₁ ≫ τ.app 𝟙_C = ε F₂` (assoc form:
  `ε F₁ ≫ τ.app 𝟙 ≫ h = ε F₂ ≫ h`). This IS the "pointwise ε-commutation equation" the project is
  stuck on, stated as a single coherence axiom.
- **Technique**: recognize the leg-B family as the unit cell of a monoidal nat-trans between the
  two `restrictScalars`-composites bridged by the `appIso`-naturality square; discharge by
  `IsMonoidal.unit` — one lemma, no reduction.
- **Mapping to project**: the ε-commutation crux (the equation that 30+ iters could not close) is
  the `unit` field of a `NatTrans.IsMonoidal` instance for the relabel comparison. ε formula at the
  carrier: `ModuleCat.restrictScalars_η : ε(restrictScalars f) r = f r`
  (`Mathlib.Algebra.Category.ModuleCat.Monoidal.Adjunction`).
- **Porting cost**: LOW-MED. Need to exhibit the monoidal-nat-trans `IsMonoidal` instance for the
  `(f.appIso V).inv` family; the unit axiom is then the target lemma rather than a hand proof.
- **Verdict**: ANALOGUE_FOUND.

### Analogue: `ModuleCat.restrictScalarsComp` + `RingCat.moduleCatRestrictScalarsPseudofunctor`
- **Domain**: change-of-rings / 2-category theory. `Mathlib.Algebra.Category.ModuleCat.ChangeOfRings`,
  `Mathlib.Algebra.Category.ModuleCat.Pseudofunctor`.
- **Same structural problem there**: `restrictScalars` assembles into a PSEUDOFUNCTOR
  `RingCatᵒᵖ → Cat`; its `mapComp` 2-cell is exactly `restrictScalarsComp (g f) ≅ comp …`. All the
  ε/restriction coherence over a diagram of ring maps is the pseudofunctor's `mapComp`/`mapId`/`map₂`.
- **Technique**: the naturality the project wants over `Opens Y` is the IMAGE of the `appIso`
  naturality square (`Scheme.Hom.appIso_inv_naturality`) under this pseudofunctor — consume the
  packaged `restrictScalarsComp`/`restrictScalarsId'` isos (the project ALREADY uses
  `restrictScalarsComp'App`/`restrictScalarsId'App` in `sliceDualTransportInv.collapse`!) instead of
  reducing pointwise.
- **Mapping to project**: glue the forward-`ε` square (after rotation via analogue #1) using
  `restrictScalarsComp'App` for the two ε-legs at `V` and `W`, intertwined by the `appIso`-naturality
  ring identity (the project's `Scheme.Hom.appIso_inv_naturality`, already used in `map_smul'`).
- **Porting cost**: MED. The coherence lemmas exist; assembling the square is bookkeeping.
- **Verdict**: ANALOGUE_FOUND.

### Analogue: `CategoryTheory.conjugateEquiv_comp` / `mateEquiv_vcomp`
- **Domain**: adjunction / mate calculus. `Mathlib.CategoryTheory.Adjunction.Mates`.
- **Same structural problem there**: conjugate/mate of a natural transformation respects vertical
  composition; the mate of a commuting square commutes automatically.
- **Technique**: cast leg-B (`inv ε` of `restrictScalars`) as the conjugate of the identity under
  the `extendScalars ⊣ restrictScalars` adjunction; mate naturality is then free.
- **Mapping to project**: would require exhibiting the `extendRestrictScalarsAdj` adjunctions at
  every section and casting the transport as a conjugate — heavy.
- **Porting cost**: HIGH. Adjunction scaffolding per section; overkill vs analogues #1-#3.
- **Verdict**: PARTIAL_ANALOGUE.

## Top suggestion
Try analogue #1 (`IsIso.inv_comp_eq` / `CommSq.horiz_inv`) FIRST, glued with #3. Concretely, in
`DualInverse.lean` rewrite both `naturality` holes (`sliceDualTransport` ~L547, `sliceDualTransportInv`
~L398) to stay at the morphism level: `apply PresheafOfModules.hom_ext; intro W`, then `rw
[IsIso.inv_comp_eq]` (with `haveI := isIso_ε_restrictScalars_appIso f _`) to push the `inv ε`
(`dualUnitRingSwap`) edge to the RHS, converting the goal into the FORWARD `ε`-naturality square.
Close that square by gluing `hφ := φ.naturality i.op` (already in hand) to the ε-leg via
`ModuleCat.restrictScalars_η` + `restrictScalarsComp'App`. This removes the `dualUnitRingSwap_apply`
rewrite that forces `inv ε` through `whnf` per element — the documented cause of the heartbeat
timeout. First file to touch: `AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean`.

## Discarded
- Mate calculus full port: overlaps directive's general "build adjunctions by hand" cost; HIGH.
- `subsingleton`: directive failed-approach #2; only the outer dual-valued square.
- Reading `restrictScalars` ε pointwise via `dualUnitRingSwap_apply`: IS the failed whnf approach #1.
