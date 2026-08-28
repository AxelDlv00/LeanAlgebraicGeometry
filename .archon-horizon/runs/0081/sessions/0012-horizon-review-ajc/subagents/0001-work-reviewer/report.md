Scan complete. Ranked findings, worst first.

## 1. `Pic0.Bundle` — VACUITY (A), the `HasDivFunctor` defect verbatim, one hop above the seam
`/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Albanese/AlbaneseUP.lean:316`

```lean
structure Bundle {kbar : Type u} [Field kbar] [IsAlgClosed kbar]
    (C : Over (Spec (.of kbar)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIrreducible C.hom] where
  scheme : Over (Spec (.of kbar))
  grpObj : GrpObj scheme
  proper : IsProper scheme.hom
  smooth : Smooth scheme.hom
  geomIrred : GeometricallyIrreducible scheme.hom
```

**Absent object: `C`.** All five fields speak only about the self-introduced field `scheme`. Nothing ties `scheme` to `Pic0Scheme C`, `Pic0SchemeEt C`, or `C`. Falsifier: none — `Spec k̄` inhabits `Bundle C` for every `C`. The docstring at `:313` calls it "Interface for `Pic⁰_{C/k̄}`"; `Pic0` does not occur in the type.

Producers: 1 (`Pic0.bundle`, `:360`). Call sites binding an *arbitrary* `Bundle`: **0** — consumers instead project the fixed `bundle C` (5 in `AlbaneseUP.lean`: `:377, :385, :389, :393, :397`, plus ~20 downstream `jacobianScheme` references across `Albanese/`).

The reason this still matters despite 0 arbitrary binders: `bundle` at `:360` does pin `scheme := Scheme.Pic0Scheme C`, so it is inert today by def-unfolding — but **no lemma records that equation**. Grep finds no `jacobianScheme = Pic0Scheme` statement anywhere; the identification exists only as a docstring sentence at `Jacobian.lean:668` ("`Pic0.jacobianScheme C` is `Scheme.Pic0Scheme C`, so the statements match on the nose"). The Albanese universal property (`AlbaneseUP.lean:620, :656, :733`) is stated against `jacobianScheme C`. One edit to `bundle`, or a second producer, changes what every Albanese theorem is about with no type error and no failing lemma. Reader is misled into believing a theorem about `(bundle C).scheme` is a theorem about the Picard identity component. Filed **I-1210**; one-line repair (`bundle_scheme … := rfl`) noted, not applied.

## 2. Five unlabelled siblings of the labelled `instPicSharpRepresentable` self-projection (B)
`/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/FGAPicRepresentability.lean`

`HasPicScheme.has_pic_scheme` (`:316`) bundles three conjuncts. Six declarations project it; the file labels exactly one.

| line | proof term | labelled? |
|---|---|---|
| `:1167` | `⟨(HasPicScheme.has_pic_scheme (C := C)).choose_spec.1⟩` | yes |
| `:1308` | `⟨(HasPicScheme.has_pic_scheme (C := C)).choose_spec.2.1⟩` | no |
| `:1339` | `(HasPicScheme.has_pic_scheme (C := C)).choose_spec.2.2` | no |
| `:647` | `Classical.choice (HasPicSchemeEt.has_pic_scheme_et (C := C)).choose_spec.1` | no |
| `:667` | `(HasPicSchemeEt.has_pic_scheme_et (C := C)).choose_spec.2.1` | no |
| `:680` | `(HasPicSchemeEt.has_pic_scheme_et (C := C)).choose_spec.2.2` | no |

The five unlabelled ones carry docstrings citing "Kleiman §4 Thm `th:main`(1)" as though the conjunct were derived; it is a projection of the declaration's own binder. `PicSharpRepresentable` binders: 1 (`representable`, `:1187`). `HasPicScheme`: 0 instances, 94 binder sites. Presentational, not unsound — the bundling is deliberate and argued at `:306-312` — but a reader auditing the other five sees citations where the correct note is "conjunct of the binder". Filed **I-1212**.

## Clean results worth recording
I read the statement of every remaining `class`/`structure` on the seam. These are **not** vacuous and **not** self-projections:

- `HasRationalPoint` (`:202`), `HasPicScheme` (`:316`), `HasPicSchemeEt` (`:576`) — fields name `C` through `picSharp C` / `picEt C` / `C.left`.
- `HasAbelMap` (`:988`, `abel : divFunctor C ⟶ picSharp C`) — mentions `C` twice; the known defect there is *property-free data*, already labelled at `:998`.
- `ClassDegree` (`IdentityComponent.lean:1487`) — mentions `C` via `(PicSharp.relPresheaf C).obj …`; inhabited by zero, already self-labelled, and `ClassDegreePinned` (`:1541`) is a genuine repair with a machine-checked refutation at `:1563`.
- `OrbitsInAffineOpen` (`FiniteGaloisQuotient.lean:195`), `HasStableAffineCover` (`:227`), `HasGaloisQuotient` (`:417`), `SemilinearGalAction` (`:165`) — all quantify over `ρ.act`/`X`; `HasGaloisQuotient` genuinely instance-free, `HasStableAffineCover` genuinely discharged from the orbit hypothesis (`StableAffineCover.lean:279`).
- `HasRigidPushforward` (`RigidPushforward.lean:387`), `HasH0Semicontinuity` (`SemicontinuityH0.lean:125`), `HasLocallyConstantDivDeg` (`DivDegree.lean:629`), `HasDivFamilyFgDescent` / `HasPicSharpFgDescent` (`FinitePresentationFunctor.lean:573, :664`), `HasTrivialConstants` (`SectionRingUniversal.lean:144`), `HasStructureSheafPushforwardIso` (`StructureSheafPushforward.lean:298`), `PullbackTensorRightUnit` (`PullbackTensorOneSided.lean:240`) — every field routes through `C.hom` or the specific `f`/`P`; the two "unconditionally discharged" claims (`instHasTrivialConstants` `:328`, `instHasRigidPushforwardOfCurve` `RigidPushforwardGammaBaseChange.lean:256`) are real instances, not gates.
- Unused-hypothesis sweep across 17 seam files found only two, both benign: `FiniteGaloisQuotient.lean:336` (`hu`) and `DivDegree.lean:688` (`hx`, absorbed by the `rfl`-provable statement).

Verdict on the sweep itself: the seam is genuinely well-swept **at the six already-labelled names**, and that is what hid both findings. The missed vacuity is the same shape as `HasDivFunctor` and sits one import hop above the files every pass reads, in the structure the Albanese universal property is stated against. Durable lesson filed as **I-1214**: scan by shape, not by name, and follow the seam into its consumer.
