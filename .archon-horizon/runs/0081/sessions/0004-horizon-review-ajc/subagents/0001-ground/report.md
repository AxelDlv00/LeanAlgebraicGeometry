Sweep complete. Filed I-0953, I-0954, I-0955 (issues) and I-0956 (memory). No source edits.

## Findings, most severe first

### 1. `HasAbelMap` — property-free data field. Docstring asserts the opposite of the truth.
`AlgebraicGeometry.Scheme.PicScheme.HasAbelMap`, `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/FGAPicRepresentability.lean:720-724`

```lean
class HasAbelMap {k : Type u} [Field k] (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] where
  abel : divFunctor C ⟶ picSharp C
```

Failure mode: **a new one, not among your four** — the named objects *do* all occur and the type is exactly right, but the field carries no property. This is the mode that survives a `Nonempty` grep.

Machine-verified (scratch, zero diagnostics, discarded): the constant-zero transformation inhabits it. Naturality is free — `map_zero (PicSharp.relFunctorial …)` — because the Pic♯ pullback maps are group homs. `@[reducible] def zeroInst : HasAbelMap C := ⟨zeroAbel C⟩` elaborates, and `@abelMap … (zeroInst C) = zeroAbel C` is `rfl`.

And the advertised consequence fails under the binder. Probing the exact conclusion of `abelMap_app_mk` (`:750-757`) against `zeroInst`:
```
Tactic `rfl` failed: (abelMap C).app T ⟦x⟧ is not definitionally equal to -⟦⟨kernel x.q, _⟩⟧
```
So the docstring at `:716-719` ("`abelMap := HasAbelMap.abel` inherits the concrete construction **and the defining property** `abelMap_app_mk`") and again at `:585-587` are both false. `abelMap_app_mk` is a theorem about `instHasAbelMap` (`:741`) alone.

Wrong conclusion a reader draws: that `[HasAbelMap C]` is safe for consumers. Under that binder `abelMap C` may be constantly zero — every divisor class maps to 0 in Pic♯. Blast radius is currently nil: the only declaration taking `[HasAbelMap C]` is `abelMap` itself (`:735`); real consumers go through `abelMapWitness` (`DivDegree.lean:678-703`, `IdentityComponent.lean:1539`).

### 2. `HasSmoothProperQuotient` — `α` does not occur in the statement.
`AlgebraicGeometry.Scheme.PicScheme.HasSmoothProperQuotient`, `FGAPicRepresentability.lean:800-803`

```lean
class HasSmoothProperQuotient {k : Type u} [Field k]
    {Z P : (Over (Spec (.of k)))ᵒᵖ ⥤ Type (u + 1)}
    (_α : Z ⟶ P) : Prop where
  is_representable : P.IsRepresentable
```

Failure mode 1 (the `HasDivFunctor` mode) on the *class*, distinct from the already-labelled `P → P` projection at `smoothProperQuotient`. Neither `α` nor `Z` occurs; only `P` does. All three of these elaborate:

- `[HasSmoothProperQuotient α] ⊢ HasSmoothProperQuotient α'` for any `α' : Z' ⟶ P`
- `[HasSmoothProperQuotient (𝟙 P)] ⊢ HasSmoothProperQuotient α`
- `[HasSmoothProperQuotient (𝟙 P)] ⊢ P.IsRepresentable`

This breaks the file's own safety argument. §3 (`:776-781`, `:821-832`) says the class is safe because the use site supplies it "for the Abel-map slice … where Altman–Kleiman descent genuinely applies", carrying quasi-projectivity of `Y`. It cannot: an instance for the identity of `P` — no equivalence relation, no smoothness, no properness in sight — discharges it for the intended `α`. The class cannot express "this quotient presentation is smooth and proper" at all. Zero instances, zero call sites at HEAD, so nothing is unsound.

### 3. Both `HasStableAffineCover` "the gate fires" witnesses sit where the gate is trivial.
`hasStableAffineCover_pullback`, `/home/axel/…/Picard/GaloisQuotientNonVacuity.lean:145-148`; `hasStableAffineCover_specF4`, same file `:186-190`. Class at `/home/axel/…/Picard/FiniteGaloisQuotient.lean:203-206`.

Failure mode 4, applied to a cover existential. Nothing here is false — both are proved, via the substantive `hasStableAffineCover_of_orbitsInAffineOpen` (`StableAffineCover.lean:279-285`, engine = prime avoidance + norm `∏_γ γ(s)` + reindexing, `:188-270`). But I proved both reachable without that engine:

- affine total space (covers `specF4`, since `Spec 𝔽₄` is affine): `⟨fun x => ⟨⊤, isAffineOpen_top X, trivial, fun _ => rfl⟩⟩`, with **no** `[FiniteDimensional K L]`, **no** `[IsGalois K L]`. `U = ⊤` is Γ-stable by `rfl`.
- the reference base-change action (i.e. `hasStableAffineCover_pullback` itself): `fst ⁻¹ᵁ U` is Γ-stable *as an open* by `pullbackGalMap_fst` alone, affine by `IsAffineOpen.preimage`. Again no finiteness, no Galois.

The module docstring (`:11-21`, `:49-70`) frames the file as answering an audit that "neither engine could fire at any object" and reports G2(a) as "fired by synthesis". A reader concludes the norm trick was exercised; it was not. The file does honestly say the object "is a point, not a curve's Picard scheme", but never that the *gate itself* is trivial there. `HasGaloisQuotient`'s depth is untouched — `hasGaloisQuotient_specF4` (`:199-200`) rests on `isGaloisQuotient_spec` (Speiser descent), which is real.

## Checked and genuinely non-vacuous

Statements read, not docstrings. Ordered by file.

`FGAPicRepresentability.lean`: `HasRationalPoint` (`:159-161`, `Nonempty` of a *section subtype* — `C.left` and `C.hom` both occur, retraction condition is real); `HasPicScheme` (`:270-275`) and `HasPicSchemeEt` (`:414-419`) — `RepresentableBy` against `picSharp C` / `picEt C` plus two morphism properties; `PicSharpRepresentable` (`:864-867`) and `PicSchemeLocallyOfFiniteType` (`:974-978`) are *pure `choose_spec` projections* of their own `[HasPicScheme C]` binder — I verified both are free given that binder — but this is disclosed in both docstrings ("its `choose_spec` is exactly this statement"), so I count them as labelled, not findings.

`PicEtSheaf.lean`: no classes. `picEt` (`:221-224`), `picEtComparison` (`:234-239`), `picEt_isSheaf_forget` (`:249-256`) all mention `C` and are proved from sheafification, not assumed.

`DivDegree.lean`: `HasLocallyConstantDivDeg` (`:629-634`) — `∀ T, ∀ x : DivFamily C.hom T, IsLocallyConstant x.fiberDeg`; `fiberDeg` (`:195-200`) is a genuine `finrank` of fibre sections, `C` occurs through `C.hom`. Not vacuous-by-emptiness in the dangerous direction (a `∀` over a possibly-empty type would be, but `DivFamily` is a 7-field structure with real content and the class would then just be weak, not misleading).

`DivFunctorDef.lean`: `DivFamily` (`:748-769`) — `isFinitePresentation`, `flat`, `properSupport`, `epi`, `kerLocallyTrivial` are all substantive; `Rel` (`:779-780`) is a real iso-over-`q` condition.

`FiniteGaloisQuotient.lean`: `OrbitsInAffineOpen` (`:184-186`) — quantifies over the actual orbit via `(ρ.act γ).hom.base x`; `HasGaloisQuotient` (`:393-396`) — `∃ Y g, IsGaloisQuotient ρ g`, and `IsGaloisQuotient` (`:374-384`) has the full `∃!` universal `T`-points clause, which is the deep part (I confirmed clauses 1–2 are free at the reference action via `Iso.refl`, but clause 3 is not).

Other `Has*` classes under `Picard/` with statements read: `HasDivFamilyFgDescent` (`FinitePresentationFunctor.lean:573-591`), `HasPicSharpFgDescent` (same file `:664-683`) — both real two-clause filtered-colimit descent; `HasRigidPushforward` (`RigidPushforward.lean:387-393`); `HasH0Semicontinuity` (`SemicontinuityH0.lean:93-96`); `HasTrivialConstants` (`SectionRingUniversal.lean:144-145`); `HasStructureSheafPushforwardIso` (`StructureSheafPushforward.lean:298-300`); `HasStableAffineCover` (statement itself is fine — see finding 3, which is about its witnesses); `PullbackTensorRightUnit` (`PullbackTensorOneSided.lean:240-243` — and its docstring at `:236-239` explicitly runs the subject-occurrence check, correctly); `IsInvertibleGr` (`SectionGradedRing.lean:151-157`); `IsSemilinear` (`GaloisDescent/SemilinearModules.lean:71-73`).

Already labelled in-tree, not re-reported: `HasDivFunctor` (`:205-206`), `smoothProperQuotient`'s `P → P` shape (`:833-847`), `ClassDegree` (`IdentityComponent.lean:1477-1482`, whose own docstring records the zero-homomorphism collapse). `ClassDegreePinned` (`:1526-1541`) is the repair and is genuinely non-vacuous — its `classDegree_abel` field pins the value on Abel images.

## Highest-value next action

Repair `HasAbelMap` (finding 1), by deletion in favour of `abelMapWitness` — nothing but `abelMap` depends on it, and this is the remedy the neighbouring `HasDivFunctor` caveat already prescribes. The alternative is adding the pin as a field, as `ClassDegreePinned` did after its own collapse. Either way the two false docstring sentences at `:716-719` and `:585-587` must go, not be softened.
