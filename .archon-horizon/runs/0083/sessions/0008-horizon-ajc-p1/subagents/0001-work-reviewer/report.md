Both items filed: issue I-1171 to `task:ajc-p1`, memory I-1172. No files edited.

## Verdict: CONVERGING. The closure claim is sound.

This is the rare one that survives an adversarial audit. Real progress, not faking. The only defect is prose, and it points the wrong way — it makes closed work read as open.

I rebuilt oleans first (`lake build AlgebraicJacobian.Picard.PicEtCrossBase`, EXIT=0, 8681 jobs) and confirmed disk blob == HEAD blob `1e7f460de3` before every probe.

## Item 1 — right statement: YES

`picEt_crossBaseIso` (`/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/PicEtCrossBase.lean:679`) is the row's obligation, correct direction. Two `rfl` probes passed: `restrictTest k k' = Over.map (Spec.map (CommRingCat.ofHom (algebraMap k k')))`, and the functor iso's value at `op T` is definitionally the row's `(picEt C).obj (op ((Over.map …).obj T))`. Not weaker, not adjacent.

## Item 2 — vacuity: REFUTED, four ways

All four `rfl` probes were **rejected** by the elaborator, so the iso has content:

- `pullback (baseChangeField C k').hom T.hom` vs `pullback C.hom ((restrictTest k k').obj T).hom` — not defeq
- `(crossBaseTotalIso C T).hom = 𝟙 _` — type mismatch, not the identity
- the two `LineBundle.OnProduct` carriers — not defeq
- `picEt (baseChangeField C k')` vs the restriction — not defeq

`crossBaseTotalIso` does real work. No declaration omits `C` or `k'` from its statement — the `HasDivFunctor` pattern does not recur here.

## Item 3 — sorry/axiom: CLEAN, control discriminated

`lake env lean` on a scratch file, all 33 declarations `[propext, Classical.choice, Quot.sound]`, EXIT=0. My deliberate `audit_control_sorry` reported `sorryAx`, so the check discriminates. Zero `sorry` after stripping comments; no `admit`, no `native_decide`.

## Item 4 — your scope claim: TRUE (this is where you were most unsure)

No hypothesis is smuggled in. Beyond the abstract instantiation, I got it to apply at a **concrete curve**:

- `picEt_crossBaseIso (p1Over ℚ) (RatFunc ℚ)` — purely transcendental, infinite degree
- `picEt_crossBaseIso (p1Over (RatFunc (ZMod 2))) (AlgebraicClosure (RatFunc (ZMod 2)))` — inseparable over an imperfect base

Both EXIT=0. That makes the result non-vacuous at an inhabited curve, not merely under a variable binder — stronger than what I-1153 claims for it.

## Item 5 — naturality: legitimate, not unification luck

I re-proved `pullbackLeftPullbackSndIso_naturality` verbatim in a standalone file importing only `Mathlib`, EXIT=0 — true as stated, independent of the project environment. And the application is definitional, by two `rfl` probes: `PicSharp.baseChangeOverC` *is* the `pullback.map` the generic lemma quantifies over, and `(baseChangeField C k').hom` *is* `pullback.snd C.hom (specMapAlgebra k k')`.

Your `IsDenseSubsite` control also holds up: `synthInstanceFailed` at the same two topologies, so the pushforward genuinely is not an equivalence.

## Item 6 — docstring honesty: SEVEN DEFECTS, all prose

Every cited name resolves (24 `#check`s, EXIT=0) — no phantom declarations. But five passages still describe the pre-closure file, left behind when `33fe30e27a` closed the residue the three earlier commits had been honestly naming:

- `:513` "the one statement this file leaves open" sits two lines under the `:510` header "**now PROVED**", and `:543` of that same docstring says "the `sorry` is gone"
- `:320` "what `relPresheaf_crossBaseIso` still owes is that it is bijective and natural in `T`" — both proved above it at `:376` and `:470`
- `:371-375` "does **not** settle naturality in `T`" — closed at `:470`
- `:615` "its hypothesis `e` is exactly the **open obligation** `relPresheaf_crossBaseIso`" — that is a proved theorem at `:568` of the same file
- `:676` "one input of **three**" contradicts `:81` "the repair has **four** inputs, not three" — which is the module docstring's own headline finding, 595 lines earlier. `FGAPicRepresentability.lean:464-495` has the count right

Two smaller: `:101` records "8865 jobs" (measured 8681); `:94` says "700 lines, of which the great majority is docstring" — counted 376 comment + 51 blank + **275 code** of 702, i.e. 54%, and 275 lines of proof term is not "short" in the sense that sentence needs to justify not transcribing the sibling's 468.

The "not portable" claim checks out: AJCR's `picEt` really is `picEtSubgroup` (an affine-opens limit, `PicEt.lean:105`) against AJC's categorical sheafification, and neither lakefile requires the other. "Closes no sorry / witnesses no antecedent" is true — `FGAPicRepresentability.lean:527` still carries its `sorry`, and the only reference to the new work anywhere outside the file is a docstring mention.

## Why the prose matters more than a typo pass

Defects 1-4 are the *careful-sounding* sentences — "what this does NOT settle", "the open obligation". A reviewer scanning for overclaiming skips exactly those. A later lane reading `:320`, `:375` or `:615` prices naturality and bijectivity as open and re-derives work already at HEAD, which is precisely what the release note I-1153 exists to prevent. Defect 5 misinforms in the other direction inside the file that corrects the count.

The roadmap row is `status: done`, owner `ajc-p1`, pinned — correctly, on the Lean. I edited nothing.
