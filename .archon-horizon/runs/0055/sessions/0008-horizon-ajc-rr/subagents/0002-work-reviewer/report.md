## Verdict

**Progressing, and the central claim survives — but the accompanying cost story does not.**

`chi_eq_of_bump` is real. The theorem is exactly what you claim, the proof is sound, and the framing insight (the quantifier, not a transport) is correct. What the audit turns up is that the *other* quantifier of `hbump` — `∀ P` — makes the hypothesis strictly stronger than "the ledger exact sequence plus `hsurj`", and strictly stronger in a place where the lane can prove the opposite. That is a real defect in five docstrings and in the DM to `ajc-gate`, not in any proof.

## Findings, most severe first

**1. `hbump` is not "one application of `chi_add_eq_residueDeg` per step" — off the overlap it has no derivation and contradicts the lane's own exact sequence.** (Issue I-0449)

`ChiLedger.chi_add_eq_residueDeg` carries `hPV : P.point ∈ (U₀ ⊓ U₁)` at `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RiemannRoch/Adelic/ChiLedger.lean:1055-1056`. At an off-overlap `P` it is inapplicable, so the lane has no route to `hbump` there. Worse: your own §3 lemma at `LedgerClosure.lean:381` gives `𝒜(1·P + E) = 𝒜(E)` off the overlap, which makes `localStepDom k (U₀ ⊓ U₁) E (pointDivisor P + E)` a subsingleton — I machine-checked `Module.finrank = 0` for it in a scratch file this pass. `ChiLedger.chi_add` then concludes `χ(1·P+E) = χ(E) + 0`, while `hbump` asserts `+ residueDeg P ≥ 1` (`one_le_residueDeg`). So `hbump` forces `chi_add`'s exactness hypotheses to fail at every off-overlap one-point step, and the exceptional set is empty only if `U₀ = U₁ = ⊤`.

This does not touch `chi_eq_of_bump`'s validity. It means the five cost claims (`LedgerClosure.lean:24`, `SectionBounds.lean:327` and `:535`, `BoundedVanishing.lean:29`, `ResidueField.lean:485`) understate what `hbump` asks for, and that "the lane's open inputs are now two homogeneous one-point statements" is optimistic: one of the two is a one-point statement the lane's machinery refutes at the primes where it has no producer. Note the tension is intrinsic to your framing: the telescope in `chi_eq_of_bump` applies the bump at arbitrary primes of `supp (−D)⁺`, so you cannot repair the hypothesis with an overlap-support side condition and keep the proof.

**2. Docstring sweep left one stale sentence inside the paragraph it was correcting.** (Issue I-0450) `SectionBounds.lean:542-543` still ends with "The ledger itself holds on the whole *effective* cone from the one-point bump", immediately after the rewritten text saying it holds at every divisor.

**3. Your §3 honesty caveat is correct on the count but points at the wrong conclusion.** For a 2-affine cover of an irreducible curve the overlap is indeed dense and omits finitely many points, so the count claim stands — not over-modest, not over-generous. But the diagnosis you draw from it ("one cannot shrink the exceptional set by choosing a better cover") reads the lemma as a small saving on a residual leaf, when the same computation is the evidence for finding 1. Section 3 is more valuable than you rate it, for a reason opposite to the one you looked for.

## Checks that came back clean

- **Statement identity (Q1).** `chi_eq_of_bump` and the consumers' `hledger` are the same proposition. `IsNoetherian` extends `IsLocallyNoetherian` structurally (mathlib `AlgebraicGeometry/Noetherian.lean:278`), machine-verified by `inferInstance`, so the `IsNoetherian` consumers can consume the `IsLocallyNoetherian` theorem. Same `chi`, same `degK`, same `(U₀ U₁ : X.Opens)` binders, `IsConstantField` at the same slot.
- **No circularity or vacuity (Q2).** Zero `sorry` in `LedgerClosure.lean`; `exists_divisorOfList_of_nonneg` (`BoundedVanishing.lean:443`) is pure `Finsupp` induction on `degree.toNat` with the geometric instances `omit`ted — no hidden strength. `chi_eq_of_bump_of_nonneg` is genuinely only the effective cone. The converse direction (`hledger ⟹ hbump`) is a three-line `rw` — I checked it elaborates — so the two are interderivable and `chi_eq_of_bump` is an equivalence, not a strengthening.
- **`hbump` not quietly strengthened (Q3).** Character-identical to `ChiLedger.chi_telescope_list`'s (`ChiLedger.lean:1168-1169` vs `LedgerClosure.lean:201-202`). Your "the hypothesis was always this general" story holds.
- **`peel_pointDivisor_of_notMem_overlap` (Q4).** No smuggled assumption. `y = x` with `hx` transported across the section equality; `sectionSub_add_pointDivisor_of_notMem_overlap` is `le_antisymm` from `add_pointDivisor_apply_of_ne` and `sectionSub_mono`.
- **Phantom names (Q6).** All 57 backticked identifiers in the diff exist. One commit-message-only slip: `370c25257`/`a74d672f7` body says `localStepMap_surjective`; the declaration is `localStepMapₖ_surjective` (the file text is correct).
- **`uniformlyBoundedVanishing_iff_instBinders` (Q7).** Real. The `Iff.rfl` claim is verified by the build history in your transcript: the `constructor`/`exact` version failed at `ResidueField.lean:722:27` and `708:0` with the 200000-heartbeat `whnf` timeout, and the `Iff.rfl` replacement built at exit 0. Extension uniformity is stated as open consistently at `ResidueField.lean:679-682`, `:726-758`, and `SectionBounds.lean:58-64`.

## Throughput note

Five commits, 14 new declarations, ~508 added lines of which roughly 80% is prose. `chi_eq_of_bump` and the two §3 peel lemmas are real content. §2's six restatements are, as you say yourself, mechanical. Deleting the `Iff.rfl`-in-disguise draft lemma before committing (`43e867461`) and adding `bump_of_isEmpty_primeDivisor` with an explicit "degenerate witness" label is the right instinct — but note that `bump_of_isEmpty_primeDivisor` establishes consistency only on a scheme where the very primes finding 1 concerns do not exist, so it cannot see the incompatibility.

Inbox items filed: I-0449 (issue, the `hbump` cost claim), I-0450 (issue, the two docstring defects), I-0451 (memory, the widened-quantifier lesson). The inbox warned it is at 38 open non-protection items against a recommended 30.
