# Mathlib-analogist directive — Route 2 Serre-vanishing transport mechanism

## Mode: api-alignment

## The situation
We are closing `higherDirectImage_openImmersion_acyclic` (`R^q j_* H = 0` for `q ≥ 1`, `j : U ↪ X` an
open immersion of an **affine** scheme `U` into a separated scheme `X`, `H` quasi-coherent on `U`).

The prover reduced its residual (via 01XJ + a corepresentability iso `sectionsFunctorCorepIso` and
`rightDerivedNatIso`) to:

    IsZero (((preadditiveCoyoneda.obj (op (jShriekOU (j ⁻¹ᵁ W)))).rightDerived q).obj H)

i.e. `Ext^q_{U.Modules}(jShriekOU_U (j⁻¹W), H) = 0`, where `j⁻¹W = U ∩ W` is a **general affine open
of the affine scheme `U`** (W ranges over a basis of affine opens of X; `U ∩ W` is affine since X is
separated). `jShriekOU_U V` is the corepresenting object of `Γ(V, −)` in `U.Modules` (Form-B absolute
cohomology: `H^p_U(V, F) := Ext^p_{U.Modules}(jShriekOU_U V, F)`).

## What we already have (DONE, axiom-clean)
- `affine_serre_vanishing {R : CommRingCat} [EnoughInjectives (Spec R).Modules] (F : (Spec R).Modules)
   [F.IsQuasicoherent] (p : ℕ) (hp : 0 < p) (e : Ext (jShriekOU (⊤ : (Spec R).Opens)) F p) : e = 0`
  — i.e. Serre vanishing ONLY for the literal scheme `Spec R`, the `⊤` open, over `(Spec R).Modules`.
- `isAffineHom_of_affine_separated` (open immersion of affine into separated ⇒ affine morphism).
- `Scheme.isoSpec : Y ≅ Spec Γ(Y, O_Y)` for `[IsAffine Y]` (Mathlib).
- `jShriekOU`, `absoluteCohomology` (= Ext form), `sectionsFunctorCorepIso`, `rightDerivedNatIso`
  (all in the project, `OpenImmersionPushforward.lean` / `AbsoluteCohomology.lean`).

## The fork I need you to resolve (minimal-LOC route)
A fresh strategy reading argues the relevant cohomology always sits on a **whole affine scheme**
(`U ∩ W` is affine), so the done `⊤`-case `affine_serre_vanishing` should suffice — with NO
generalization of affine vanishing to arbitrary affine opens. But there are still TWO potential gaps
between the prover's residual and that `⊤`-case. Tell me, with concrete Mathlib decl names + the
minimal-LOC path, how each is bridged (and whether one is avoidable by re-decomposing the leaf):

1. **Change-of-scheme (⊤-case).** Does a scheme iso `e : Y ≅ Spec Γ(Y)` (`Scheme.isoSpec`) induce an
   equivalence of module categories `Y.Modules ≌ (Spec Γ(Y)).Modules` under which `jShriekOU_Y ⊤` and
   the coefficient sheaf transport, so that `Ext^q_{Y.Modules}(jShriekOU_Y ⊤, H) ≅
   Ext^q_{(Spec Γ Y).Modules}(jShriekOU_{Spec} ⊤, H') = 0`? Name the Mathlib pieces:
   - Is there a `Scheme.Modules` / `SheafOfModules` pullback-equivalence along an iso of schemes?
     (e.g. `SheafOfModules.pullback`/`pushforward` of an iso forming an equivalence; or
     `CategoryTheory.Equivalence` transported through the underlying ringed-space iso.)
   - Does `Abelian.Ext` transport along such an equivalence (it should: any additive equivalence
     preserves Ext — `CategoryTheory.Abelian.Ext` invariance under equivalence)?
   - Does `jShriekOU` commute with the equivalence (it is `sheafify(free(yoneda V))`; the equivalence
     should send `jShriekOU_Y ⊤` to `jShriekOU_{Spec} ⊤`)?

2. **Locality / ⊤-reduction.** The prover's residual is over a general open `V = j⁻¹W` of `U`, not `⊤`.
   Is there a clean bridge `Ext^q_{U.Modules}(jShriekOU_U V, H) ≅ Ext^q_{V.Modules}(jShriekOU_V ⊤,
   H|_V)` (absolute cohomology of an open subscheme = intrinsic cohomology of that subscheme)? OR is it
   cheaper to **re-decompose the `_acyclic` leaf BEFORE the corepresentability step** so it lands
   directly on the intrinsic `⊤`-case of the affine scheme `V = j⁻¹W` (e.g. compute `R^q j_* H` via
   `H^q(j⁻¹W, H)` recognized as intrinsic affine-scheme cohomology, then `⊤`-case + change-of-scheme)?
   Which is the minimal-LOC, least-circular path? (NB: the project already knows span-cover descent is
   circular; any route must avoid it. The 01EO basis mechanism is fine.)

## Deliverable
A ranked recommendation (route + concrete Mathlib/project decl names + rough LOC) for the minimal path
from the prover's coyoneda residual to `e = 0`, naming exactly which transport lemmas must be built
project-side vs. which are off-the-shelf. Write the persistent rationale to `analogies/o2-serre-transport.md`.
