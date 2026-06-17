# Blueprint-writer directive — iter-066 — rewrite `_comp` part (2) + cleanup

Chapter: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (the consolidated
chapter; covers `OpenImmersionPushforward.lean` and `CechSectionIdentification.lean`).

You have `references/**` in your write-domain only so a child reference-retriever can run
if needed; you edit ONLY the chapter above.

## Context (strategy slice)
`higherDirectImage_openImmersion_acyclic` (part (1), `R^q j_* = 0` for an affine open
immersion `j : U ↪ X`, U affine, X separated, H qcoh) is now FULLY PROVEN axiom-clean
(iter-065). The live work is part (2): `higherDirectImage_openImmersion_comp`,
```
  R^k f_*(j_* H) ≅ R^k (f∘j)_* H        (H qcoh on U, f : X → S any morphism)
```
proved via `Functor.rightDerivedIsoOfAcyclicResolution` (= `lem:acyclic_resolution_computes_derived`)
with `G = pushforward f`, `K = (pushforward j)(I•)` the pushed-forward injective resolution
of `H`. The Lean skeleton is in place with FOUR open obligations (hacyc / eRes / hexact /
transport). **The current blueprint proof of part (2) is on a FLAWED route and must be
rewritten** — see below.

## TASK 1 (load-bearing) — rewrite the part-(2) proof of `lem:open_immersion_pushforward_comp`

The current proof (chapter lines ~9243–9264 and the "(2a)/(2b)" Ext-transport detail
after ~9301) proves the `f_*`-acyclicity of `j_* I^n` by claiming
`H^k(U ∩ f^{-1}(V), I^n|_{U∩f^{-1}V}) = 0` "by Serre vanishing on the affine open
`U ∩ f^{-1}(V)`". This is WRONG: for `V ⊆ S` affine, `f^{-1}(V)` is open in `X` but NOT
affine in general, so `U ∩ f^{-1}(V)` is a general open of the affine `U` and need NOT be
affine — the claim at lines ~9311–9314 that "`U ∩ f^{-1}(V)` is an affine open of `U`
because `j` is affine" is false (it would need `f^{-1}(V)` to be an affine open of `X`,
which it is not). This path also re-enters the restriction-of-injectives wall the project
deliberately avoids. DELETE this argument (the whole "Each `j_*I^n` is `f_*`-acyclic …"
paragraph and the "(2a)/(2b)" Ext-over-`U` transport detail for part (2)).

Replace with the actual, cleaner Lean route, written as four clearly-labelled
obligations matching the Lean `case`s:

- **(b) hacyc — each `j_* I^n` is `f_*`-acyclic.** `pushforward j` preserves injective
  objects: it is the right adjoint in `pullback j ⊣ pushforward j`
  (`Scheme.Modules.pullbackPushforwardAdjunction j`), and the left adjoint `pullback j`
  preserves monomorphisms because, for an open immersion `j`, `pullback j` is isomorphic
  to the exact restriction functor `restrictFunctor j`
  (`Scheme.Modules.restrictFunctorIsoPullback`) — restriction of a sheaf of modules to an
  open subscheme is exact, hence preserves monos. By `Injective.injective_of_adjoint`
  (`lem:injective_of_adjoint`, already in the chapter) applied to this adjunction, `j_* I^n`
  is injective in `X.Modules` for each injective `I^n`. An injective object is
  right-`G`-acyclic for ANY additive functor `G` (`Functor.IsRightAcyclic.ofInjective`,
  `def:right_acyclic`), so `j_* I^n` is `(pushforward f)`-acyclic. (No Serre vanishing on
  `U ∩ f^{-1}(V)`; the restriction-of-injectives wall is avoided.)
- **(a) hexact — `j_* I•` is exact in positive degrees.** The homology of the pushed-forward
  resolution `K = (pushforward j)(I•)` in degree `k` computes the right-derived functor:
  `H^k(j_* I•) ≅ R^k j_* H = higherDirectImage j k H` (right-derived via the injective
  resolution `I•`). By part (1) (`higherDirectImage_openImmersion_acyclic`, H qcoh on the
  affine U) this vanishes for `k ≥ 1`, so `K.ExactAt (n+1)` for all n.
- **eRes — augmentation `j_* H ≅ K.cycles 0`.** `pushforward j` is left exact
  (finite-limit-preserving, being a right adjoint), so it carries the resolution
  augmentation `H ≅ (I•).cycles 0` to `j_* H ≅ (j_* I•).cycles 0 = K.cycles 0`
  (equivalently `H^0(j_* I•) = R^0 j_* H = j_* H`).
- **transport — `H^k(f_*(K)) ≅ R^k (f∘j)_* H`.** Compose with
  `pushforwardComp j f : pushforward j ⋙ pushforward f ≅ pushforward (j ≫ f)` and the
  right-derived-object transport `isoRightDerivedObj`; mechanical.

Then `Functor.rightDerivedIsoOfAcyclicResolution (pushforward f) K (j_* H) eRes hexact k`
composed with `transport` yields the stated iso. Keep the high-level statement and its
Stacks `lemma-relative-affine-vanishing` SOURCE/SOURCE QUOTE for part (1)/the statement,
but make clear in prose that the part-(2) `f_*`-acyclicity is established by the
formalization-friendly categorical route (adjoint preserves injectives + injectives are
`G`-acyclic), an equivalent and cleaner alternative to Stacks' presheaf-description
argument.

Update the `\uses{}` of BOTH the lemma block and its proof block to reflect the new route:
ADD `lem:injective_of_adjoint`, `def:right_acyclic` (the `Functor.IsRightAcyclic` /
`ofInjective` block — locate its label; it lives with `lem:acyclic_resolution_computes_derived`),
and the Mathlib anchors below. REMOVE the now-unused deep deps that only served the flawed
Ext-over-`U∩f^{-1}V` route IF they are no longer referenced by the rewritten proof
(`lem:affine_serre_vanishing_general_open`, `lem:modules_isoSpec_ext_transport`,
`lem:sectionsFunctorCorepIso`, `lem:rightDerivedNatIso`,
`lem:isZero_coyoneda_rightDerived_of_forall_ext_eq_zero`,
`lem:ext_jShriekOU_eq_zero_of_specIso`, `lem:ext_homcomplex_mathlib` — but KEEP whichever
part (1) still legitimately uses; part (1) `higherDirectImage_openImmersion_acyclic` is now
its own block per TASK 2, so the part-(2) block need only `\uses` part (1)'s label plus the
new route's deps).

### Mathlib dependency anchors to author (mark `\mathlibok`, with the real `\lean{}`)
Add anchor blocks (project notation + `\lean{}` naming the Mathlib decl) for any not yet
present:
- `Scheme.Modules.pullbackPushforwardAdjunction` — `pullback f ⊣ pushforward f`.
- `Scheme.Modules.restrictFunctorIsoPullback` — `restrictFunctor f ≅ pullback f` for open immersion f.
- `CategoryTheory.Injective.injective_of_adjoint` — already `lem:injective_of_adjoint`; reuse.
- `Scheme.Modules.pushforwardComp` — `pushforward j ⋙ pushforward f ≅ pushforward (j≫f)`.

## TASK 2 — split `higherDirectImage_openImmersion_acyclic` into its own block
It is currently co-pinned in `lem:open_immersion_pushforward_comp`'s `\lean{}` together
with the still-open `higherDirectImage_openImmersion_comp`, so its closed milestone cannot
get an independent `\leanok`. Create a SEPARATE `\begin{lemma}` block
`lem:open_immersion_pushforward_acyclic` with `\lean{AlgebraicGeometry.higherDirectImage_openImmersion_acyclic}`
holding part (1)'s statement + proof (move part (1)'s prose there), and have
`lem:open_immersion_pushforward_comp` `\uses{lem:open_immersion_pushforward_acyclic}`.
Keep `isAffineHom_of_affine_separated` pinned with whichever block uses it.

## TASK 3 — correct the φ'' proof sketch
`lem:slice_reverse_ring_map` (~lines 10385–10444): the proof describes a 2-part
codomain-bridge construction (`sheafPushforwardContinuousComp'` + an explicit object-relabel
iso) that the Lean never builds. Replace with the actual argument: both
`Functor.sheafPushforwardContinuousComp` and `Over.mapForget` are DEFINITIONAL (`Iso.refl`
/ `rfl`), so the codomain bridge is absorbed by defeq and φ'' is simply
`sliceStructureSheafHom φ.symm (φ.inv ⁻¹ᵁ Ui)` retyped along the (defeq) corrected-inverse
codomain. Keep the statement and `\lean{}` unchanged.

## TASK 4 — cleanup
- Fix the stale `% NOTE (review iter-064)` on `lem:pushPull_coprod_prod` (~line 8477) which
  describes `pushPull_coprod_prod_empty` and `coprodToProd_isIso_of_equiv` as still open:
  both were CLOSED iter-065 and `pushPull_coprod_prod` + Stubs 2/4 are axiom-clean. Update
  or remove the note to reflect this.
- Coverage: add `AlgebraicGeometry.isZero_modules_of_isEmpty` (new private helper supporting
  the empty-base case) to the `\lean{}` list of `lem:pushPull_coprod_prod_empty`.

## Out of scope
Do NOT touch `\leanok` markers (deterministic sync owns them). Do NOT edit any Lean file.
Do NOT alter the CSI Stub 5/6 blocks (`lem:cechSection_complex_iso`,
`lem:cechSection_contractible`) — they were rated adequate. Do NOT change frozen statements.

## Report
List each block edited, the new `\uses{}` sets, and any `\mathlibok` anchors added. Flag
any strategy-modifying finding under a `## Strategy-modifying findings` heading.
