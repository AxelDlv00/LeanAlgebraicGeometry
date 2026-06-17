# Mathlib Analogist Report

## Mode
cross-domain-inspiration

## Slug
d3-mate271

## Iteration
271

## Structural problem
Prove the unit-cocycle / pentagon coherence for the composite of two adjunctions whose left adjoints are
each a composite `L = Q ∘ F` (`Q` a reflective localization/sheafification, `F` a base-change/pullback),
where the comparison `(Q∘F)(h) ∘ (Q∘F)(f) ≅ (Q∘F)(h≫f)` is itself a nontrivial 2-cell. The surgical
blocker: a functor-wrapped comparison factor `forget.map ((pullback h).map ((sheafCompPb f).hom.app P))`
has no transposable head, so `leftAdjointUniqUnitEta_app` (= `homEquiv_leftAdjointUniq_hom_app`) cannot
rewrite it into the inner composite-adjunction unit `B_f.unit`.

## Analogues (summary)

| Analogue | Domain | Porting cost | Verdict |
|---|---|---|---|
| `conjugateEquiv_whiskerLeft` (`Adjunction/Mates.lean:525`) | category theory / mate calculus | low–medium | ANALOGUE_FOUND |
| `leftAdjointCompNatTrans_assoc` + `…_eq_conjugateEquiv_symm` (`Adjunction/CompositionIso.lean:155,130`) | cat. theory; *is* the sheaf-pullback setting | medium–high | ANALOGUE_FOUND |
| `unit_mateEquiv` / `unit_leftAdjointUniq_hom_app` (`Mates.lean:133`, `Unique.lean:51`) | mate calculus | low | ANALOGUE_FOUND |
| `Adjunction.localization` / `localization_unit_app` (`Localization/Adjunction.lean:90,121`) | localization of adjunctions | high | PARTIAL_ANALOGUE |

## Top suggestion
The missing device is **`CategoryTheory.Adjunction.conjugateEquiv_whiskerLeft`
(`Mathlib/CategoryTheory/Adjunction/Mates.lean:525`)**:
```
conjugateEquiv (adj.comp adj₁) (adj.comp adj₂) (whiskerLeft L τ) = whiskerRight (conjugateEquiv adj₁ adj₂ τ) R
```
This is *exactly* "the conjugate (homEquiv transpose between two left-adjoint factorizations) of an
`L`-whiskered comparison `τ` (with `adj : L ⊣ R`) equals the `R`-whiskered conjugate". In the project,
the stuck factor `(pullback h).map ((sheafCompPb f).hom.app P)` is `(whiskerLeft (pullback h)
(sheafCompPb f).hom).app P`, with `pullback h` the left adjoint of `pullbackPushforwardAdjunction h`.
Instantiating `conjugateEquiv_whiskerLeft` with `adj := the h-composite-adjunction`, `adj₁/adj₂ := A_f, B_f`,
`τ := (sheafCompPb f).hom` (a `conjugateEquiv`-image of identity, since `sheafCompPb f = leftAdjointUniq A_f B_f`
and `leftAdjointUniq := (conjugateIsoEquiv …).symm (Iso.refl _) |>.symm`, Unique.lean:36) gives that factor a
conjugate/`homEquiv` head — precisely what `leftAdjointUniqUnitEta_app` consumes. The sheaf↔presheaf wrapping
`forget`/`restrictScalars` is already crossed by the landed `forget_map_pushforward_map`.

Read, in order: `Mates.lean:525–544` (`conjugateEquiv_whiskerLeft` + `_whiskerRight`, 4-line `ext;simp`
proofs), `Mates.lean:338` (`conjugateEquiv_comp`, the `@[reassoc (attr := simp)]` combiner), and the
end-to-end model `CompositionIso.lean:130–164` — which proves the *exact sibling cocycle one functor over*
and whose real consumer is `PullbackContinuous.lean:192` `SheafOfModules.pullback_assoc :=
leftAdjointCompIso_assoc …` (same file family as the project's `sheafificationCompPullback`). First project
file to touch: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:2638` (the open `sorry` in
`sheafificationCompPullback_comp_tail`) — add the `have` that re-expresses the factor as `whiskerLeft …`,
transposes via `conjugateEquiv_whiskerLeft`, and hands the conjugate-headed result to `leftAdjointUniqUnitEta_app`.

## Discarded
- `Adjunction.localization` sectionwise/`liftNatTrans` close: its `natTrans_ext`-on-`L₁.obj` reduction is a
  genuinely different (universal-property) technique, retained as PARTIAL — but its `liftNatTrans` *definition*
  route is high-cost and would require recasting `B_φ` from `Adjunction.comp` to `Adjunction.localization`.
- Pure `Adjunction.comp_unit_app` + `unit_naturality` reassembly: matches directive failed-approach #3
  (inner factors never present a head) — only viable once `conjugateEquiv_whiskerLeft` supplies the head.

## Notes on the two failed-transpose worries
- This is NOT failed-approach #2 ("transpose the whole tail → circular"). The `conjugateEquiv` route
  (CompositionIso recipe) `obtain ⟨τ,rfl⟩ := surjective` each comparison as a conjugate of an explicit
  *pushforward* (right-adjoint) transformation, then `injective` lands the content on the pushforward side,
  where Mathlib's coherence is sectionwise trivial (`pushforwardComp_hom_app_app = 𝟙 _`). The earlier
  circular attempt re-folded the SAME left-adjoint statement; here the content genuinely moves to the
  right-adjoint side.
- `unit_leftAdjointUniq_hom_app` (Unique.lean:51, `@[reassoc (attr := simp)]`) is the unit-prefixed form that
  recovers `G.map (leftAdjointUniq.hom.app x)` with no homEquiv head — but its wrapping functor must be the
  *right* adjoint `pushforward f`. The project's wrapping is `pullback h` (left adjoint of the OTHER
  adjunction), so `conjugateEquiv_whiskerLeft` is needed first to cross adjunctions.

## Persistent file
- `analogies/d3-mate271.md` — analogue list + ported recipe captured for future iters.

Overall verdict: ANALOGUE_FOUND — `conjugateEquiv_whiskerLeft` (Mates.lean:525) is the precise missing
"functor-wrapped comparison → conjugate/homEquiv head" device; the CompositionIso `leftAdjointCompNatTrans_assoc`
recipe (already used by Mathlib for the sibling `SheafOfModules.pullback_assoc`) is the non-circular fallback.
