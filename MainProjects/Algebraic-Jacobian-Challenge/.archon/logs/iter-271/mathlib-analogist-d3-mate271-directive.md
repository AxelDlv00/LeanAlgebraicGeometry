# Mathlib-analogist directive — iter-271 (D3′ sheafification mate step)

## Mode: cross-domain-inspiration

## Structural problem
We have two adjunctions whose left adjoints are built as `sheafification ∘ (presheaf-level pullback)`
(call them `B_f ⊣` for a morphism `f`, and `B_h ⊣` for `h`). We need to prove a *composite-adjunction
unit cocycle* identity at the sheaf level: the unit of the composite adjunction `B_{h≫f}` factors, after
crossing the sheaf↔presheaf forgetful boundary, as

  η^{h≫f} ≈ η^f.app P ≫ (pushforward …).map (η^h.app (pullback_f P)) ≫ (pushforwardComp h f).hom

i.e. the standard "unit of a composite of two adjunctions" law `Adjunction.comp_unit_app`, BUT each left
adjoint is `a ∘ pushforward`-flavoured (sheafification `a` composed with a presheaf pullback), so the
naive `Adjunction.comp_unit_app` + `unit_naturality` reassembly does NOT fire: the recovery of the inner
factors R1/R5 as `B_f.unit`/`B_h.unit` requires reframing `forget.map ((pullback h).map (sheafComp f).hom)`
through the f-adjunction `homEquiv` (a "hinner" reframing), and the analogue of the
`unitToPushforwardObjUnit_comp` step that was `rfl` one level up (for plain pushforward adjunctions) is
NOT rfl here because the units are *composite* (sheafify∘pushforward) adjunctions. The single missing
device is a `have` that exhibits `forget.map ((pullback h).map (sheafCompPullback f).app P)` with a
`homEquiv` head so that the project's axiom-clean brick `leftAdjointUniqUnitEta_app` can fire.

Abstractly: **prove the unit-cocycle / pentagon coherence for the composite of two adjunctions whose left
adjoints are each a composite `L = Q ∘ F` (Q a reflective localization/sheafification, F a base-change
functor), where the comparison `(Q∘F)(h) ∘ (Q∘F)(f) ≅ (Q∘F)(h≫f)` is itself a nontrivial 2-cell.**

## Failed approaches
- Sectionwise `hom_ext; intro U; rfl`: the composite-adjunction unit is NOT sectionwise trivial (the
  sheafification unit `toSheafify ≫ restrictHomEquivOfIsLocallySurjective` expands and contaminates).
- Transposing the WHOLE tail equation back through `homEquiv`: proven CIRCULAR by hand (iter-263).
- `Adjunction.comp_unit_app` + `unit_naturality` directly: the inner factors never present a `homEquiv`
  head, so `leftAdjointUniqUnitEta_app` cannot rewrite R1/R5 into `B_f.unit`/`B_h.unit`.
- The bridge `forget ∘ pushforward^sheaf = pushforward^pre ∘ forget` (`forget_map_pushforward_map`) is
  now PROVEN axiom-clean (rfl) and wired in — it crosses the boundary but does NOT supply the homEquiv
  reframing for the inner units.

## Search radius
wide — any Mathlib domain where a composite/iterated adjunction unit-cocycle is proven when the left
adjoints are localizations/reflectors composed with another functor (e.g. sheafification + pullback,
localization + restriction of scalars, reflective-subcategory composites, Day-convolution / Kan-extension
mates, bicategorical pseudofunctor lax-unity for composite 1-cells). Return: the Mathlib citation, the
technique used to recover the inner units (especially any `homEquiv`/`leftAdjointUniq`/mate trick), and a
concrete suggestion for porting it to the sheafify∘pullback setting.
