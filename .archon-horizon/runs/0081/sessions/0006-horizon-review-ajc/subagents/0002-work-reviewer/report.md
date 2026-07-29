Audit complete. Filed I-1018, I-1019 (issues) and I-1020 (memory). Scratch files deleted and confirmed gone; I edited nothing in the tree.

## Verdict

The étale half is **structurally sound and materially more honest than the legacy half** — no vacuity, no self-projection, one real sorry. But it carries an **unlabelled defect of a third kind** that the legacy half does not: the word "Unconditional." on extractions that are sorry-reachable at every real curve.

Neither of the two patterns you asked about is present on the étale side. `HasPicSchemeEt` is genuinely non-vacuous (measured, with calibration), and no étale declaration proves `P → P`. The `choose_spec` bodies look like the labelled legacy self-projections but are not: they project a class whose field is a real statement about `C`, from a `sorry` upstream, which is honest derivation.

## Question 1 — vacuity

`HasPicSchemeEt` passes. Its field mentions `PicScheme.picEt C`, so it is falsifiable. Measured rather than read: I attempted the transport `[HasPicSchemeEt C] → HasPicSchemeEt C'` and it **failed** with an application type mismatch on `picEt C` vs `picEt C'`. Calibration matters here — in the same probe file the known-vacuous `HasDivFunctor` transport **compiled**, so the probe distinguishes the two cases rather than failing for an unrelated reason.

All eleven targets name their object. The two whose statements do not mention `PicSchemeEt` — `picEtCommGrp` and `picEtCommGrpForgetIso` (lines 561, 569) — are not supposed to: they are functor-level constructions about `PicSharp.etaleSheaf C`, which does occur. No vacuity anywhere on this half.

## Question 2 — self-projection and the sorry

Two of the eleven call the line-489 `sorry` directly:
- `instHasPicSchemeEt` — body `⟨(fgaPicardRepresentability C).1⟩`
- `picEtComparison_isIso_of_hasRationalPoint` — body `(fgaPicardRepresentability C).2 inferInstance`

`picSchemeOfHasRationalPoint` destructures it in a tactic block. All three report `sorryAx`.

Six project their own `[HasPicSchemeEt C]` binder (`PicSchemeEt`, `representableEt`, the two carrier instances, `groupSchemeStructureEt`, via `.choose` / `.choose_spec.1` / `.2.1` / `.2.2`) and are individually axiom-clean. This is *not* the labelled `smoothProperQuotient` defect: that theorem's class field is literally its own conclusion (`P.IsRepresentable → P.IsRepresentable`), whereas here the class field is an existential about `picEt C` and the extractions genuinely extract.

## The distinction you asked to be stated exactly

Both halves of it are true simultaneously, and the gap between them is the honest state of the project:

- **Declaration-level:** `PicSchemeEt`, `representableEt`, `instPicSchemeEtLocallyOfFiniteType`, `instPicSchemeEtIsSeparated`, `picEtCommGrp`, `picEtCommGrpForgetIso`, `groupSchemeStructureEt` → `[propext, Classical.choice, Quot.sound]`. A bound instance argument is never unfolded, so this is a fact about the *implications*.
- **At a real curve:** `Adelic.p1Over k` (`Picard/RigidPushforward.lean:552`) satisfies all three binders. Every one of `HasPicSchemeEt (p1Over k) := inferInstance`, `PicSchemeEt (p1Over k)`, and the downstream `Pic0Et.finiteDimensional_cotangentSpace (p1Over k)` → **`sorryAx`**.

`lake env lean` EXIT=0; imports verified current beforehand by `lake build` EXIT=0 (8710 jobs, sole warning the line-481 `sorry`).

One further measurement sharpens this: `[HasPicSchemeEt C]` **is not a gate**. A declaration carrying only the three geometric binders and *not* naming the class synthesises it anyway and obtains `representableEt C`, `sorryAx`. Control in the same file: `[HasPicScheme C] := inferInstance` **fails** with `synthInstanceFailed`, so the legacy class really is instance-free. Every consumer that writes `[HasPicSchemeEt C]` could have omitted the binder with no change in strength.

## Question 3 — which are unlabelled (the actionable output)

**Unlabelled, docstring-only fixes**, in value order — details in I-1018:

1. **Lines 542 and 551** — `instPicSchemeEtLocallyOfFiniteType` and `instPicSchemeEtIsSeparated` each end `"extracted from the étale existence package. Unconditional."` A bare "Unconditional." is precisely the word a reader takes as "holds today at a curve." Highest value of the eleven.
2. **Lines 517-519** — `PicSchemeEt`: *"the honest `Pic_{C/k}` of the project — available for every smooth proper geometrically integral curve"*. True as an implication; no mention that the availability **is** the sorry firing.
3. **Lines 534, 585** — `representableEt`, `groupSchemeStructureEt`: same shape, no sorry mention. (`groupSchemeStructureEt`'s "needs no rational point" is true and is not the issue.)
4. **Lines 491-492** — `HasPicSchemeEt`: *"consumers can quantify over it as a hypothesis and stay kernel-clean"* — undeliverable at a use site, since the class is always synthesisable from the sorry.

**Already correctly labelled, leave alone:** `instHasPicSchemeEt` (504-507, names `fgaPicardRepresentability` as its mathematics) and `picSchemeOfHasRationalPoint` (640-644, *"It carries no `sorry` of its own: both inputs are clauses of the seam's single open obligation"*).

**A separate stale claim** (I-1019): lines 606-621 describe `picEtComparison_isIso_of_hasRationalPoint` as *"a hypothesis class that a consumer must supply explicitly at the use site"* — three paragraphs after line 100 admits `PicEtComparisonIso` never existed. It is a plain theorem binding `[HasRationalPoint C]` whose body calls the sorry, so *"deliberately not given a `sorry`-bodied carrier of its own"* is backwards, and the `HasSmoothProperQuotient` parallel is inverted (that one really is a class). This is the same docstring slot failing a second time in a different way — the names were fixed, the sentence describing the mechanism was not.

## The asymmetry worth acting on

`Picard/Pic0EtTangentSpace.lean:59-67` states the implication-vs-use-site distinction exactly right, and `scripts/axiom-frontier.lean:1293-1300` does too — with a real `p1Over`-free but synthesis-site probe section. The **seam file that owns the sorry** is the one place that does not, and it is where a reader arrives first. Two of three places are honest; the source of truth is the one that isn't.

Relevant absolute paths:
- `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/FGAPicRepresentability.lean`
- `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/Pic0EtTangentSpace.lean`
- `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/scripts/axiom-frontier.lean`
- `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/RigidPushforward.lean` (`p1Over`, line 552)
