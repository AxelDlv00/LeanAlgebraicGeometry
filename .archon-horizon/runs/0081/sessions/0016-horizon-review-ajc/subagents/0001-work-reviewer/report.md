Filed I-1356, I-1357, I-1358, I-1359. I edited no Lean file.

## Verdict

**No unlabelled `HasDivFunctor`-shaped vacuity exists on this seam.** The census found exactly one other statement-level vacuity (`HasSmoothProperQuotient`) and it already carries an honest label. All three known self-projections carry honest in-file labels, and there is **no fourth**. The live defects are all of the *other* kind — the statement mentions its object, the **proof** ignores a binder — and two of those are unlabelled.

Verdict on the seam's own health: **converging on honesty, not on mathematics**. The labelling discipline here is genuinely good (unusually so). What is churning is the caveat layer: corrections land in the file being edited and their copies one file over go stale, which happened twice more this round.

## (a) VACUITY — statement does not mention its object

| Site | Decl | Verdict | Labelled? |
|---|---|---|---|
| `FGAPicRepresentability.lean:248` | `HasDivFunctor` | VACUOUS (known) | Yes |
| `FGAPicRepresentability.lean:1301` | `HasSmoothProperQuotient` | **VACUOUS in its index** | **Yes** |

`HasSmoothProperQuotient` field verbatim, with binders `(_α : Z ⟶ P)`:
```lean
  is_representable : P.IsRepresentable
```
Neither `α` nor `Z` occurs. I confirmed the consequence by probe (EXIT=0): from `[HasSmoothProperQuotient α]` one derives `HasSmoothProperQuotient α'` for **any** other `α' : Z' ⟶ P` with the same target. Its docstring already says "`α` IS A DECORATIVE INDEX". Honest.

Every other class field on the seam genuinely constrains `C`: `HasRationalPoint` (`C.left`, `C.hom`), `HasPicScheme` / `HasPicSchemeEt` (`picSharp C` / `picEt C`), `HasAbelMap` (`divFunctor C ⟶ picSharp C`, and its property-freeness is labelled), `PicSharpRepresentable`, `PicSchemeLocallyOfFiniteType` (`PicScheme C`). `SemilinearCotangentComparisonEt` mentions `C` three times. `PicEtSubcanonical`, `PicEtSeparated`, `Pic0Et`, `PicEtDescentAssembly` declare no vacuous structure.

## (b) SELF-PROJECTION

I swept every instance body for `choose_spec` / `Classical.choice` / class-field projections. **No unlabelled case.** All are labelled:

- `smoothProperQuotient:1334` — labelled "this theorem is `P.IsRepresentable → P.IsRepresentable`". Verified: closes with **all four numbered hypotheses, plus `Y`, `R`, `π` and both instance binders, deleted** (EXIT=0).
- `instPicSharpRepresentable:1392` — `⟨…choose_spec.1⟩` under `[HasPicScheme C]`. Labelled "THIS CLASS IS A SELF-PROJECTION AND CARRIES NO MATHEMATICS".
- `instPicSchemeLocallyOfFiniteType:1542` — `⟨…choose_spec.2.1⟩`. Same label.
- `PicScheme.isSeparated:1573` and `instPicSchemeEtIsSeparated:887` / `instPicSchemeEtLocallyOfFiniteType:874` — `choose_spec.2.2` / `.2.1`. These project a class the declaration *binds*, but the class is the seam's existential rather than the conjunct itself, so they are extractions, not `P → P`. `PicSchemeEt`, `representableEt` likewise.

## (c) UNUSED HYPOTHESES — the real findings

**`/…/AlgebraicJacobian/Picard/PicEtSeparated.lean:276`, `locallyOfFiniteType_of_baseChange` — UNUSED-HYP, NOT labelled, docstring asserts the opposite.** Carries `[Algebra.IsSeparable k k']` and `[Module.Finite k k']`; the proof consumes **neither**. The body verbatim with both deleted elaborates, EXIT=0; `lean_minimal_hypotheses` independently calls the explicit `(k' : Type u)` binder removable. Control: with `h` dropped, `infer_instance` fails. The docstring says field 2 descends "for `k'/k` finite separable ... surjectivity from `Scheme.surjective_specMap_algebraMap`, the other two outright" — but all three hold for an arbitrary field extension. This is the *same* double-count the seam docstring already corrected at its input 2. (I-1356)

**`Pic0EtTangentSpace.lean:389` `finrank_cotangentSpace_eq_genus` and `:415` `subsingleton_h1Cok_of_genus_eq_zero` — UNUSED-HYP, not labelled.** Both carry `[GeometricallyIrreducible C.hom]` *and* `[GeometricallyIntegral C.hom]`. Measured: `GeometricallyIntegral` **synthesises** `GeometricallyIrreducible` (control: without it, `infer_instance` fails), and both theorems elaborate with the `GeometricallyIrreducible` binder deleted. Minor, but it is a binder a reader prices.

## Two stale claims, both withdrawn elsewhere the same day (I-1357)

`/…/AlgebraicJacobian/Picard/PicEtDescentAssembly.lean`:
- `:303` "one of the **five** scheme flat-descent instances mathlib has" — withdrawn at `FGAPicRepresentability.lean:617-628` as "eleven, not five". I recounted: 5 in `LocalFlatDescent.lean`, 6 more in `FlatDescent.lean`.
- `:308` "The one brick is a port of AJCR's `AbelianVariety/GroupSeparated.lean`" — false at HEAD; the port landed as `PicEtSeparated.lean`, and the seam docstring already records that retraction. All three names verified present and axiom-clean.

## An unpropagated discount (I-1358)

`PicEtSeparated.lean` establishes the **seam's** clause (1) is two-field, but nothing propagates it to the classes. Measured, all axiom-clean:
- `HasPicSchemeEt` is a two-field class — the full class is constructible from `∃ X, Nonempty (…RepresentableBy X) ∧ LocallyOfFiniteType X.hom`.
- The **legacy** `HasPicScheme` is two-field too (no file says this): field 3 follows from field 1 via `picSharp_representableBy_picEt_transport` then `isSeparated_of_representableBy_picEt`.
- So `instPicSchemeEtIsSeparated` is now provable without `choose_spec.2.2`.

Control confirming this is a real and *bounded* discount: `LocallyOfFiniteType X.hom` does **not** follow from `rep` (synthInstanceFailed), so field 2 is genuinely still owed. `HasPicScheme`'s docstring justification "Bundling therefore adds no strength beyond representability" is now provable for field 3 and measurably false for field 2.

## Suspicions (not confirmed)

- `Pic0Et.lean:201` `isSeparated` and `:232` `proper` route through `instPicSchemeEtIsSeparated`, so if that instance is restated per I-1358 they change proof but not statement. I did not probe whether `Pic0Et.isSeparated` is independently free from the group structure.
- I could not verify the docstring claim at `PicEtSeparated.lean:37-44` that `DescendsAlong @IsSeparated` and `DescendsAlong @IsClosedImmersion` fail to synthesise — an olean vanished mid-probe (another lane rebuilding) and I did not re-run it. The absence is plausible from the mathlib grep (neither appears among the eleven registrations) but was not measured by me.

Method note: one probe returned "Imports are out of date" mid-session while other lanes rebuilt — the recorded `I-1057` trap. Every finding above was re-run through `lake env lean` **with a control that must fail**, after `lake build` returned EXIT=0 (8705 jobs).
