/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib

/-!
# FGA representability of the Picard scheme (A.2.c)

This file is the **A.2.c** assembly file-skeleton sub-build chapter for the
project's positive-genus arm of `nonempty_jacobianWitness`. It wires the
Quot-scheme engine (A.2.b, sibling `Picard/QuotScheme.lean`) and the
étale-sheafified relative Picard functor (A.1.c, sibling
`Picard/RelPicFunctor.lean`) into the FGA representability statement for
`Pic_{C/k}`, following Kleiman, "The Picard scheme", §4 (cf. FGA Explained
Ch. 9 §9.4; arXiv:math/0504020).

## Status (iter-176 Lane I file-skeleton)

This file is the **iter-176 Lane I** file-skeleton (re-dispatch of the iter-175
Lane I that died to the Anthropic session-limit reset window without ever
calling `Write`). Each of the five blueprint-pinned declarations carries the
*intended* substantive type signature (matching the `\lean{...}` pin in
`blueprint/src/chapters/Picard_FGAPicRepresentability.tex`) with a `sorry`
body. The bodies are iter-177+ work, gated on the sibling chapters
`Picard/RelPicFunctor.lean` (A.1.c) and `Picard/QuotScheme.lean` (A.2.b)
landing their pinned declarations.

The 5 pinned declarations are:

1. `AlgebraicGeometry.Scheme.PicScheme` (def, ~5 LOC) — the **Picard scheme**
   `Pic_{C/k}` as an object of `Over (Spec k)`, the witness extracted from
   the `Functor.RepresentableBy` produced by `representable`.
2. `AlgebraicGeometry.Scheme.PicScheme.abelMap` (def, ~6 LOC) — the
   **Abel map** `A_{C/k} : Div_{C/k} ⟶ Pic^♯_{(C/k)ét}` as a natural
   transformation of presheaves on `(Sch/k)^op`.
3. `AlgebraicGeometry.Scheme.PicScheme.smoothProperQuotient` (theorem, ~15 LOC)
   — the Altman–Kleiman **smooth-proper quotient lemma** (Kleiman §4
   Lem. `lm:qt`) packaging the descent from a flat-and-proper equivalence
   relation `R ⊆ Z ×_k Z` on a quasi-projective `k`-scheme `Z` to a
   representing quotient `Q`.
4. `AlgebraicGeometry.Scheme.PicScheme.representable` (theorem, ~12 LOC) —
   the **FGA representability theorem** (Kleiman §4 Thm. `th:main`,
   specialised via Cor. `cor:algsch` to `S = Spec k` and `X = C` a smooth
   proper geometrically integral curve): the étale-sheafified relative
   Picard functor is represented by `PicScheme`.
5. `AlgebraicGeometry.Scheme.PicScheme.groupSchemeStructure` (instance,
   ~6 LOC) — the **group-scheme structure** on `PicScheme`: a `GrpObj`
   instance obtained by Yoneda transport of the abelian-group structure
   on `Pic^♯_{(C/k)ét}`.

## Note on type expressivity

Following the project rule "Never weaken the type to dodge the proof", each
pinned declaration carries a substantive, non-tautological type:

- `PicScheme C : Over (Spec (.of k))` — a scheme over `k`, not a
  tautological `Spec k`.
- `abelMap C : divFunctor C ⟶ picSharp C` — a genuine natural
  transformation of presheaves, not `𝟙 _` (it sends a relative effective
  divisor to its associated invertible sheaf).
- `smoothProperQuotient` carries the four Kleiman §4 Lem. `lm:qt`
  hypotheses (Z represented, R representable, smooth+proper first
  projection, étale surjection) and concludes `P.IsRepresentable`. The
  hypotheses are not vacuous: any one of (i)–(iv) can fail for a
  non-quotient morphism of presheaves.
- `representable C : (picSharp C).RepresentableBy (PicScheme C)` — the
  substantive Yoneda-bijection structure between `Hom(T, PicScheme C)` and
  `picSharp C |_T`.
- `groupSchemeStructure C : GrpObj (PicScheme C)` — a genuine group-object
  structure, with multiplication / inverse / unit morphisms satisfying the
  group axioms.

The two file-internal auxiliary defs `picSharp` and `divFunctor` (placeholders
for the sibling-chapter functors `Pic^♯_{(C/k)ét}` and `Div_{C/k}`) are
typed-`sorry` *carriers* used to express the 5 pinned declarations' types
without forward-referencing into Lean files that have not yet landed. They
ship in the `AlgebraicGeometry.Scheme.PicScheme` namespace, marked with
docstrings explaining they will be re-exports of the sibling-chapter
landing once `Picard/RelPicFunctor.lean` and `Picard/QuotScheme.lean` land
(forward refs `AlgebraicGeometry.Scheme.PicSharp` and
`AlgebraicGeometry.Scheme.divFunctor` per their blueprint `\lean{...}`
pins). Their bodies collapse to a one-line `:= ...` re-export at that
point.

## References

Blueprint: `blueprint/src/chapters/Picard_FGAPicRepresentability.tex` (640 LOC,
5 pins). Source: Kleiman, "The Picard scheme", §4 (FGA Explained Ch. 9 §9.4;
arXiv:math/0504020 pp. 25–35), specifically:
- §3 Def. `dfn:Abel` (the Abel map) + Thm. `th:repDiv` (relative effective
  divisors representable by an open subscheme of the Hilbert scheme),
- §4 Main Thm. `th:main` + Cor. `cor:algsch` (FGA representability),
- §4 Lem. `lm:qt` (smooth-proper quotient of étale sheaves).
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry

namespace Scheme

namespace PicScheme

/-! ## §0. File-internal placeholders for the sibling-chapter functors

The two presheaves `Pic^♯_{(C/k)ét}` (the étale-sheafified relative Picard
functor; sibling chapter `Picard/RelPicFunctor.lean`, A.1.c, pin
`AlgebraicGeometry.Scheme.PicSharp`) and `Div_{C/k}` (the relative-effective-
divisor functor; sibling chapter `Picard/QuotScheme.lean`, A.2.b, pin
`AlgebraicGeometry.Scheme.divFunctor`) are forward references; the sibling
Lean files have not yet landed. For the iter-176 file-skeleton we encode
both as typed-`sorry` auxiliary defs in this namespace so the 5 pinned
declarations below can mention them substantively.

Once the sibling files land, both defs collapse to a one-line re-export. -/

/-- **File-internal placeholder** for the étale-sheafified relative Picard
functor `Pic^♯_{(C/k)ét} : (Sch/k)^op ⥤ Type u` of
`Picard/RelPicFunctor.lean` (A.1.c).

The blueprint chapter `Picard_RelPicFunctor.tex` pins this functor under the
name `AlgebraicGeometry.Scheme.PicSharp`; once that sibling file lands the
present def becomes a one-line re-export
`fun C => AlgebraicGeometry.Scheme.PicSharp C`. Until then it is a typed
`sorry` carrier. -/
noncomputable def picSharp {k : Type u} [Field k]
    (_C : Over (Spec (.of k))) :
    (Over (Spec (.of k)))ᵒᵖ ⥤ Type u :=
  sorry

/-- **File-internal placeholder** for the relative-divisor functor
`Div_{C/k} : (Sch/k)^op ⥤ Type u`, sending a `k`-scheme `T` to the set of
relative effective Cartier divisors on `C ×_k T` flat over `T`.

The blueprint chapter `Picard_QuotScheme.tex` pins the Quot/Hilbert engine
under `AlgebraicGeometry.Scheme.QuotScheme`; the divisor functor here is the
open sub-functor cut out by the effective-divisor criterion (Kleiman §3
Thm. `th:repDiv`). Once `Picard/QuotScheme.lean` lands the present def
collapses to a one-line re-export. Until then it is a typed `sorry`
carrier. -/
noncomputable def divFunctor {k : Type u} [Field k]
    (_C : Over (Spec (.of k))) :
    (Over (Spec (.of k)))ᵒᵖ ⥤ Type u :=
  sorry

end PicScheme

/-! ## §1. The Picard scheme

The Picard scheme `Pic_{C/k}` of a smooth proper geometrically integral curve
`C/k` is the `k`-scheme representing the étale-sheafified relative Picard
functor `Pic^♯_{(C/k)ét}`. It is supplied by Kleiman §4 Thm. `th:main`
(specialised to `S = Spec k`, `X = C` via Cor. `cor:algsch`); the
representability theorem itself is the next declaration (`representable`),
and `PicScheme` is the witness scheme extracted from it.

The scheme is separated, locally of finite type over `k`, and a disjoint
union of open quasi-projective `k`-subschemes; the abelian-group-scheme
structure is the content of `groupSchemeStructure`.

Blueprint reference: `def:pic_scheme` (Kleiman §4 Def. `df:Psch`). -/

/-- The **Picard scheme** `Pic_{C/k}` of a smooth proper geometrically
integral curve `C/k`.

Encoded as an object of `Over (Spec (.of k))` (a `k`-scheme), carrying the
substantive identity "this is the scheme representing `Pic^♯_{(C/k)ét}`"
via the `RepresentableBy` witness produced by
`AlgebraicGeometry.Scheme.PicScheme.representable`. The structural
properties (separated, locally of finite type, disjoint union of open
quasi-projectives) live on the underlying scheme via the standard
instances of `Over (Spec (.of k))`.

iter-177+: the body extracts the representing object from
`representable C`, e.g.
`(representable C).choose` modulo a `Functor.RepresentableBy` witness; or
constructs it directly via the four-step Kleiman §4 Thm. `th:main` proof
(Hilbert-polynomial stratification, `m`-regularity bound, Abel-map
factorisation, smooth-proper quotient). For the iter-176 file-skeleton the
body is a typed `sorry`. -/
noncomputable def PicScheme {k : Type u} [Field k]
    (_C : Over (Spec (.of k))) : Over (Spec (.of k)) :=
  sorry

namespace PicScheme

/-! ## §2. The Abel map — line-bundle / Quot correspondence

The bridge from line bundles on `C ×_k T` to the Quot scheme is the **Abel
map**: a relative effective divisor `D ⊆ C ×_k T` over `T` (an `S`-flat
closed subscheme whose ideal is invertible) determines a `T`-point of the
Hilbert functor `Hilb_{C/k}(T)` (hence of `Div_{C/k}(T)`), and the dual
ideal sheaf `O_{C ×_k T}(D) := I_D⁻¹` is an invertible sheaf on the
relative curve, representing a class in `Pic^♯_{(C/k)ét}(T)`.

The assignment `D ↦ [O_{C ×_k T}(D)]` is functorial in `T` (pullback of an
ideal sheaf along `id_C ×_k g : C ×_k T' ⟶ C ×_k T` takes the ideal of `D`
to the ideal of `D_{T'}`, since `D` is flat over `T` and hence
`D_{T'} = D ×_T T'` is again a relative effective divisor by Kleiman §3
Lem. `lm:ctn`).

Blueprint reference: `lem:line_bundle_quot_correspondence` (Kleiman §3
Def. `dfn:Abel` + Thm. `th:repDiv`). -/

/-- The **Abel map** `A_{C/k} : Div_{C/k} ⟶ Pic^♯_{(C/k)ét}`, sending a
relative effective Cartier divisor `D ⊆ C ×_k T` over `T` to its associated
invertible sheaf `[O_{C ×_k T}(D)] = [I_D⁻¹]`.

A natural transformation of presheaves on `(Sch/k)^op`. The source
`divFunctor C` is the relative-divisor functor (the open subfunctor of the
Hilbert/Quot scheme cut out by the effective-divisor criterion); the target
`picSharp C` is the étale-sheafified relative Picard functor.

iter-177+: the body constructs the natural transformation component-wise:
for each test `T`, send a relative effective Cartier divisor `D` on
`C ×_k T` to the dual of its ideal sheaf, then take the étale-sheafified
class. Naturality is the functoriality of the dual-of-ideal-sheaf
construction under pullback (Stacks 01HG + Kleiman §3 Lem. `lm:ctn`).
For the iter-176 file-skeleton the body is a typed `sorry`. -/
noncomputable def abelMap {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] :
    divFunctor C ⟶ picSharp C :=
  sorry

/-! ## §3. The smooth-proper quotient lemma — Altman–Kleiman descent

The structural lemma underlying Step 4 of Kleiman §4 Thm. `th:main` is the
Altman–Kleiman **smooth-proper quotient lemma**: given a surjection
`α : Z ⟶ P` of étale sheaves with `R := Z ×_P Z` representable, `Z`
quasi-projective, and the first projection `R ⟶ Z` smooth and proper,
the quotient `P` is representable by a quasi-projective scheme.

Kleiman's proof:
1. `R ↪ Z ×_k Z` is a flat (from (iv)) and proper monomorphism, hence a
   closed immersion by EGA IV 8.11.5.
2. By the theory of flat-and-proper effective equivalence relations on
   quasi-projective schemes (Altman–Kleiman), there exist a
   quasi-projective scheme `Q` and a faithfully flat, projective map
   `Z ⟶ Q` with `R = Z ×_Q Z`. The map `Z ⟶ Q` is smooth (its fibers
   coincide with those of `R ⟶ Z`, which are smooth).
3. In the category of étale sheaves, both `Q` and `P` are coequalisers of
   `R ⇒ Z`; uniqueness of the coequaliser gives `Q ≃ P`.

Blueprint reference: `lem:smooth_proper_quotient` (Kleiman §4 Lem.
`lm:qt`). -/

/-- **The smooth-proper quotient lemma — Altman–Kleiman descent of an
étale-sheaf surjection.**

Let `Z, P : (Sch/k)^op ⥤ Type u` be presheaves on `(Sch/k)^op`, and let
`α : Z ⟶ P` be a natural transformation. Assume:
1. `Z` is representable by a `k`-scheme `Y` (encoded by the
   `Z.RepresentableBy Y` hypothesis),
2. the pullback presheaf `R := Z ×_P Z` is representable by a `k`-scheme `R`
   (encoded by the `(Limits.pullback α α).RepresentableBy R` hypothesis),
3. the first projection `π : R ⟶ Y` (after representation) is smooth and
   proper (encoded by the typeclass hypotheses `[Smooth π.left]` and
   `[IsProper π.left]`),
4. `α` is an étale surjection (encoded as the lift property: every
   `T`-point `p ∈ P(T)` lifts to a `T'`-point `z ∈ Z(T')` for some test
   morphism `T ⟶ T'`).

Then `P` is representable (by a quasi-projective `k`-scheme `Q`).

iter-177+: the body builds `Q` via the Altman–Kleiman effective quotient
of the flat-and-proper equivalence relation `R ↪ Y ×_k Y`, then exhibits
the coequaliser-uniqueness in the category of étale sheaves to identify
`Q` with the representing object of `P`. For the iter-176 file-skeleton
the body is a typed `sorry`. -/
theorem smoothProperQuotient {k : Type u} [Field k]
    {Z P : (Over (Spec (.of k)))ᵒᵖ ⥤ Type u}
    (α : Z ⟶ P)
    (Y : Over (Spec (.of k)))
    (_hZ : Z.RepresentableBy Y)
    (R : Over (Spec (.of k)))
    (_hR : (Limits.pullback α α).RepresentableBy R)
    (π : R ⟶ Y)
    [Smooth π.left] [IsProper π.left]
    (_hα : ∀ ⦃T : (Over (Spec (.of k)))ᵒᵖ⦄ (p : P.obj T),
        ∃ (T' : (Over (Spec (.of k)))ᵒᵖ) (e : T ⟶ T') (z : Z.obj T'),
          α.app T' z = P.map e p) :
    P.IsRepresentable := by
  sorry

/-! ## §4. The FGA representability theorem

Grothendieck's existence theorem for the Picard scheme (Kleiman §4 Thm.
`th:main`), specialised via Cor. `cor:algsch` to `S = Spec k`,
`X = C` a smooth proper geometrically integral curve: the étale-sheafified
relative Picard functor `Pic^♯_{(C/k)ét}` is representable by a `k`-scheme,
separated and locally of finite type, which is a disjoint union of open
quasi-projective `k`-subschemes. The representing scheme is the **Picard
scheme** `Pic_{C/k}` of `PicScheme` above.

Blueprint reference: `thm:fga_pic_representability` (Kleiman §4 Thm.
`th:main` + Cor. `cor:algsch`). -/

/-- **FGA representability of the Picard scheme.**

Let `k` be a field and `C` a smooth proper geometrically integral curve
over `k`. Then the étale-sheafified relative Picard functor `Pic^♯_{(C/k)ét}`
is representable by the Picard scheme `PicScheme C`.

iter-177+: the body assembles the four-step Kleiman §4 Thm. `th:main` proof:
1. Stratify `Pic^♯_{(C/k)ét}` by Hilbert polynomial into a disjoint open
   cover `(P^φ)_φ`.
2. For each `φ`, bound twists by `m`-regularity to reduce to `P^{φ_0}_0`.
3. Factor through the Abel map `A_{C/k}` of `abelMap` to obtain
   `Z := P^{φ_0}_0 ×_{Pic^♯} Div_{C/k}`, a quasi-projective open of
   `Div_{C/k}`.
4. Apply `smoothProperQuotient` to the projection `Z ⟶ P^{φ_0}_0` to
   represent each `P^{φ_0}_0`; reassemble over `φ` for the full
   `Pic^♯_{(C/k)ét}`.

For the iter-176 file-skeleton the body is a typed `sorry`. -/
noncomputable def representable {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] :
    (picSharp C).RepresentableBy (PicScheme C) :=
  sorry

/-! ## §5. The abelian group-scheme structure

The Picard scheme `Pic_{C/k}` inherits an abelian group-scheme structure
from the tensor product of invertible sheaves on `C ×_k T`. The relative
Picard presheaf `T ↦ Pic(C ×_k T)/π_T^* Pic(T)` is already an abelian
group at every `T` (the quotient of an abelian group by a subgroup),
functorially in `T`; this lifts to the étale sheafification (sheafification
of an abelian-presheaf is an abelian-sheaf, since it commutes with finite
products in the value category), and then to a group-scheme structure on
the representing scheme by Yoneda.

Blueprint reference: `thm:pic_is_group_scheme` (Kleiman §2 Def. `df:Pfs` +
§4 Def. `df:Psch`). -/

/-- **The Picard scheme is a `k`-group scheme.**

The Picard scheme `PicScheme C` carries a canonical `GrpObj` structure (a
group-object structure in `Over (Spec (.of k))`), obtained by Yoneda
transport of the abelian-group structure on `Pic^♯_{(C/k)ét}(T)` (sum:
`[L] + [M] = [L ⊗ M]`; inverse: `-[L] = [L⁻¹]`; unit: `[O_{C ×_k T}]`).

The full abelian-group-scheme refinement is the conjunction of this `GrpObj`
instance with the `IsCommMonObj (PicScheme C)` predicate (commutativity of
the multiplication), which holds because tensor product of invertible
sheaves is symmetric; `IsCommMonObj` is a separate instance threaded on top
of `GrpObj` in iter-177+.

iter-177+: the body invokes the Yoneda lemma to transport the natural
abelian-group structure on `T ↦ picSharp C |_T` to the multiplication /
inverse / unit morphisms on `PicScheme C`; the group axioms hold at the
representable level functorially in `T`, hence on the representing scheme
by Yoneda. For the iter-176 file-skeleton the body is a typed `sorry`. -/
noncomputable instance groupSchemeStructure {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] :
    GrpObj (PicScheme C) :=
  sorry

end PicScheme

end Scheme

end AlgebraicGeometry
