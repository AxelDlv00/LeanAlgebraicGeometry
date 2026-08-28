Confirmed. Both delegated audits stalled without returning; I completed those ranges directly.

## Ranked genuine findings

**1. `AlgebraicJacobian/Picard/Pic0Et.lean:100, :123, :113, :201` — `Pic0Et.grpObj` / `locallyOfFiniteType` / `geometricallyIrreducible` / `isSeparated` — all four are labelled "**PROVED**, unconditionally" and all four are `sorryAx`-reachable at any use site, because their `[HasPicSchemeEt C]` binder is not a gate: `instHasPicSchemeEt` is an unconditional instance built on the bare `sorry` at `FGAPicRepresentability.lean:525`.**

This is the `HasDivFunctor` shape one level up: the binder that looks like an assumption discharges itself. Confirmed with an axiomatized field and a curve carrying only the three geometric instances, gate *not* assumed:

```
'useGrp' depends on axioms: [CC, instG, instP, instS, kk, kkField, propext, sorryAx, Classical.choice, Quot.sound]
```
identically for `useSep`, `useLft`, `useGir`. Two controls in the same probe: `(inferInstance : HasPicScheme CC)` fails with `synthInstanceFailed` (so the legacy class really is instance-free), and `cleanCtl := zariskiTopologyOver_le_etaleTopologyOver kk` returns `[kk, kkField, propext, Classical.choice, Quot.sound]` — no `sorryAx` — so the marker is not an artifact of axiomatizing the field.

Why this ranks first: `Pic0SchemeEt` is consumed by 7 files including `Jacobian.lean`, `Albanese/AlbaneseArbitraryField.lean` and `AVRigidityArbitraryField.lean`. The distinction is stated correctly in `FGAPicRepresentability.lean:583-600` and in `Pic0EtRelativeDimension.lean` / `Pic0EtTangentSpace.lean` — but **`Pic0Et.lean` itself carries no such caveat** (grep for `instHasPicSchemeEt|not a gate|sorryAx|synthesiz` in it returns only two hits, both about `GeometricallyReduced`, neither about the gate). So the file that a reader of the headline arrives at presents four self-discharging statements as proved. Its `smooth`/`proper` are honestly marked `sorry`; these four are not.

**2. `AlgebraicJacobian/Picard/SemicontinuityH0.lean:125` and `:111` — `HasH0Semicontinuity` / `H0UpperSemicontinuity` — the class and its statement pin carry *no* properness, smoothness or flatness binder on `C`, while the docstring's own honesty audit (lines 26-33) grounds truth in "`X = C_A` is proper flat over `Spec A`".**

`#check` shows the gate's type is `{k} → [Field k] → Over (Spec (CommRingCat.of k)) → Prop` — `C` is an arbitrary `k`-scheme. Both extraction theorems inherit this: `isOpen_setOf_fiberH0_le` binds only `[CommRing A] [Algebra k A] [Algebra.FiniteType k A] [HasH0Semicontinuity C]`. Confirmed statable at a bare `C` with no geometric hypotheses, with the control `(inferInstance : HasRigidPushforward C)` failing at the same bare `C` (its producer *does* require the three binders). Not vacuity — the class is uninhabited (0 instances, 2 call sites, both inside its own file) — but the gate as written asks for a statement broader than the one the audit certifies, so whoever discharges it will find the pin unprovable at the stated generality.

**3. `AlgebraicJacobian/Picard/IdentityComponent.lean:1781` — `Pic0Scheme.inclusion` — obtains the clopen immersion from `isOpenSubgroupScheme` and then discards it (`obtain ⟨f, -⟩`), concluding only `Nonempty ((Pic0Scheme C).left ⟶ (PicScheme C).left)`, a bare morphism with no property.**

The discarded data is free: I typechecked the strictly stronger `Nonempty {f // IsOpenImmersion f.left ∧ IsClosedImmersion f.left}` as a direct application of `GroupScheme.IdentityComponent.isOpenSubgroupScheme G`, no extra work. Low surface (2 docstring references, no code consumers), which is why it ranks third — but `kPoints_iff_kerDegree:1959` re-derives the same inclusion inside its own `sorry`, so a consumer wanting the immersion cannot use this lemma.

**4. `AlgebraicJacobian/Picard/PicEtSheaf.lean:132` — `zariskiTopologyOver_le_etaleTopologyOver` — zero real consumers; its only mention outside the file (`PicEtSubcanonical.lean:335`) is a docstring saying it is *not* needed.** Also `etaleSheaf_isSheaf:180` and `etaleSheafHomEquiv:204` have 0 consumers each; `etaleSheaf_isSheaf` is a tautology of sheafification, not a fact about the curve — I restated it for an arbitrary presheaf on an arbitrary site with the same one-line `.property` proof, and the control (same proof against the *un*sheafified presheaf) failed as it must.

## Clean

- **`Picard/DivPushforwardFlat.lean`** — clean, and unusually accurate about itself. I verified its two self-audit claims: `LocallyQuasiFinite` genuinely occurs nowhere else in `Picard/`, and the file genuinely has zero consumers. `CoherentSheafFlat (𝟙 X) F` is **not** free (probe failed for arbitrary and for quasicoherent `F`; the arbitrary-morphism control also failed), so the three flatness conclusions have content.
- **`Picard/PicEtSubcanonical.lean`** — clean. Consumer counts match its own claims; `not_representableBy_picSharp_of_not_isIso_picEtComparison` is a real contrapositive, not `P → P`.
- **`Picard/GrassmannianRepresentability.lean`** — no classes or structures; the three `∃ Y, Nonempty (… RepresentableBy Y)` statements at :383/:563/:598 are fully constrained (the witness is pinned in the proof and `V`, `d`, `r` all occur). Worth noting rather than reporting as a defect: the file is hard-pinned to `Scheme.{0}` (15 sites) — instantiating `representable_of_iso_free` at generic universe `u` fails with a universe mismatch, so the D3'/G-cluster consumers at universe `u` cannot use it as written.
- **`Picard/DivFunctorDef.lean`, `Picard/DivDegree.lean`** — no new findings. `HasFiberDeg`'s empty-base vacuity is real (I proved every `d` and `d'` hold simultaneously when the base is empty, control failed) but the file documents it at :381 and :428. `HasLocallyConstantDivDeg`: 0 instances, 1 call site. `ClassDegree`/`ClassDegreePinned` are already labelled.
- **`Picard/RigidPushforward.lean`** — clean, and its strongest claim checks out. `HasRigidPushforward` is genuinely discharged: `instHasRigidPushforwardOfCurve` and `hasRigidPushforward_p1Over` both report `[propext, Classical.choice, Quot.sound]`, no `sorryAx`, and it synthesizes at an abstract curve while the `HasPicScheme` control fails. One thing I could **not** settle: `Hom.FiberH1Vanishing:279` has 45 mention sites and zero producers, and I tried to show it is free on affine fibres via a degenerate `U₁ = U₂` Mayer–Vietoris square. The square exists and satisfies `U₁ ⊓ U₂ = U₁`, but `U ⊓ U` is not definitionally `U` in `Opens`, so the surjectivity transport did not close. Unproven either way — do not price it as free on my account.

## Highest-value next action

Add the `FGAPicRepresentability.lean:583-600` caveat to `Pic0Et.lean`, or drop the word "PROVED" from those four docstrings. Finding 1 is the only one on the headline path, and the correct text already exists verbatim in three sibling files — this is a copy, not new mathematics. Until it lands, the file that states the Jacobian candidate's properties reads as four-of-six done when the four are conditional on the same `sorry` as the two that are marked open.

One process note: `FGAPicRepresentability.lean`'s sorry moved 511→512→517 and its olean was invalidated twice during this session, so another lane is editing that file live. My line numbers are from disk at the time of reading, not from HEAD.
