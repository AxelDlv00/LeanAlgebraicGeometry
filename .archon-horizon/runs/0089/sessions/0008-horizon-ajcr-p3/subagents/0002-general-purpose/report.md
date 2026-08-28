The `SendMessage` to `work-reviewer` failed — no agent by that name is reachable from this session, so I could not reply directly. Relaying the answer here instead; my audit was already complete when the message arrived.

## (C) REFUTED — on two independent grounds

**The pinned pair is not genuinely needed by that lemma.** `deg_presentationDivisor_eq_finrank_glued` (`/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/DivisorFamilyFieldDegree.lean:336`) touches `cover₀`/`cover₁` at exactly one place, lines 356-358, inside the `hinner` step:

```lean
rw [← relCover_sup C K (fiberTwoCover π)]
exact sup_le (A.cover₀.trans ...) (A.cover₁.trans ...)
```

Its only purpose there is to derive `(⊤ : Opens) ≤ ⨆ j, A.pieces j` — "every point lies in some piece" — so the proof can pick `j₀` with `p.1 ∈ pieces j₀`. That is verbatim the widened `AffCoverData.cover` field (`DivisorFamilyAffCover.lean:154`), and the lemma is already landed on the widened side as `AffCoverData.exists_mem_pieces` (`DivisorFamilyAffCover.lean:166-168`), one line from the joint sup. Both `#check` clean. The two-chart structure is used only to index the sum, exactly the adversarial case flagged in the brief. The docstring at `DivisorFamilyAffAbel.lean:210` has it backwards — the joint sup is more convenient than `relCover_sup` plus two partitions of unity, not less.

**That lemma is not on the chain being audited.** `deg_divFamDivisor` (`DivisorFamilyFieldCRT.lean:376-381`) proves it via the unconditional CRT identity:

```lean
rw [divFamDivisor_mk, G.adaptation.deg_presentationDivisor, G.certified.finrank_glued]
```

`DivisorAdaptation.deg_presentationDivisor` (`DivisorFamilyFieldCRT.lean:324`) takes no separation hypothesis. The separated route is superseded — the CRT file says so itself at :375 — and has zero consumers outside `DivisorFamilyFieldDegree.lean`. The live route's CRT engine, `DivisorFamilyStalkEval.lean`, has grep count 0 for `cover₀`/`cover₁`/`relCover_sup`/`partition₀₁`/`V₀`/`V₁`/`fiberTwoCover`, and the per-piece keystone `finrank_quotient_span_section` (`AlgebraicJacobian/RiemannRoch/ChartColength.lean:411`) is stated for an arbitrary affine open `V ∋ η`. The live route's single pinned-pair use is `DivisorAdaptation.exists_mem_pieces` (`DivisorFamilyFieldCRT.lean:179-185`) — the same one-line lemma.

## (F) Nothing exists

No declaration in the workspace concludes `deg`/`classDeg`/`CurveDivisor.deg`/`degAt` from `AffAdaptation`, `DivFamZarAff`, `IsLocallyCertifiedAff`, or `divFamZarAff`. Of the 27 files mentioning `AffAdaptation`, the only degree-flavored results are `Module.rankAtStalk` (`DivisorFamilyAffRank.lean:67,88,144`; `DivisorFamilyAffCert.lean:402`) — module rank, not divisor degree. The sibling project has zero mentions of either carrier. So `hdegAff` is genuinely undischarged; the file is right that something is owed.

## Net

(F) survives; the causal explanation offered for it does not. `DivisorFamilyAffAbel.lean:199-202` and `:255-258` are overstated and should be weakened. What is actually owed is a transcription of roughly 760 lines of chart-free stalk/CRT argument (`DivisorFamilyStalkEval.lean` 349 + `DivisorFamilyFieldCRT.lean` 409), whose one genuinely chart-typed input is already supplied on the widened side.

(A) confirmed (`DivSchemeAbel.lean:295`). (B) confirmed for both names (`DivSchemeAbel.lean:144`, `:159`). (D) confirmed as an absence claim, but three of the four names belong to the dead separated route and are not needed — right measurement, wrong shopping list. (E) confirmed, all five `#check` on `AffAdaptation` (`DivisorFamilyAffAdaptation.lean:171/182/233/245/252`), `IsCertified` clause-identical to `DivisorFamily.lean:426`; only `eqn_ne_zero` lacks a widened form, a two-line corollary of the present `eqn_regular`.

Read-only throughout, no edits. Measurements are from disk rather than `git show HEAD:` — the worktree carries other lanes' uncommitted changes, so a HEAD-level re-check is worth doing before anything is written on top of this.
