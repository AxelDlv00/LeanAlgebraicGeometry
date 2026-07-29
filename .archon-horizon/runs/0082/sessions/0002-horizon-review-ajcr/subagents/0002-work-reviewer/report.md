Good, this confirms the "swallowedBy" cover producer avoids `ChartTyping` entirely, consistent with the certificate side being chart-free. Now I have everything for the priority report.

## Status report (priority items requested)

Read-only throughout. No edits, no commit, no `lake build` (build mutex still contended per original constraint).

### 1. `IsCertified` / `IsLocallyCertified`, "seven clauses" — DivisorFamily.lean:426, DivisorFamilyAffAdaptation.lean:252

Read both structures in full, plus `chartProd`/`ovlProd`/`gluedSubmodule`/`deltaLeft`/`deltaRight` (DivisorFamily.lean:334-441) that the clauses quantify over.

```
structure IsCertified (n : ℕ) : Prop where
  finite_colength : ∀ j, Module.Finite R (A.colength j)        -- (c1)
  projective_colength : ∀ j, Module.Projective R (A.colength j) -- (c1)
  finite_glued : Module.Finite R A.Glued                        -- (c2)
  projective_glued : Module.Projective R A.Glued                -- (c2)
  rankAtStalk_glued : ∀ p, Module.rankAtStalk A.Glued p = n     -- (c2)
  flat_coker_incl : Module.Flat R (A.chartProd ⧸ A.gluedSubmodule)          -- (c3)
  flat_coker_diff : Module.Flat R (A.ovlProd ⧸ range(deltaLeft-deltaRight)) -- (c4)
```

**No clause is vacuous as stated** — I checked each against what it quantifies over:
- `colength j := Γ(pieces j) ⧸ (eqn j)` — a real quotient ring depending on the actual equation, not degenerate.
- `Glued := ker(deltaLeft - deltaRight)` inside `chartProd = ∀ j, colength j` — a real equalizer submodule (`mem_gluedSubmodule_iff` gives the honest componentwise-agreement description, DivisorFamily.lean:408-413).
- `rankAtStalk_glued` is a genuine constant-rank condition over every prime — this is where the actual "degree n" content lives, and it's stated correctly with no vacuous quantifier (index `PrimeSpectrum R` is always nonempty for `R` a ring, and rank is a real invariant).
- (c3)/(c4) are flatness of two specific, non-trivially-constructed cokernels — nothing in their statement is degenerate; `Module.Flat R M` for arbitrary `M` is a real condition.

The **label-vs-field-count mismatch I flagged earlier stands but is cosmetic, not a vacuity defect**: "all seven clauses" (field count = 7) is used throughout the file family (DivisorFamilyAffCert.lean:12,46, DivisorFamilyAffCompare.lean:34,197, DivisorFamilyAffZar.lean:135, DivisorFamilyAffGlue.lean:60, JacobianDataAbelSquare.lean:27, etc. — grepped `seven` across the whole tree, only 4 grouped labels (c1)-(c4) ever appear, never (c5)/(c6)/(c7) anywhere in the tree). This is a naming convention (7 proof obligations grouped into 4 named clauses), not a hidden vacuous side condition — I traced every field back to its actual mathematical content and found none trivially true.

One structural point worth flagging directly to your priority: **the certificate side is index-agnostic and does not depend on `ChartTyping` at all** — confirmed by re-reading `AffCoverData` (DivisorFamilyAffCover.lean:145-152): its only structural demand is `cover : ⨆ j, pieces j = ⊤` plus each piece affine. So `IsCertified`'s "seven clauses" are **not** where a ChartTyping-style index-emptiness could hide — they're stated over `AffCoverData.index := Fin D.m`, always inhabited whenever `D.m > 0`, and every producer I found (`DivSchemeCertZarSeed.lean:88`, `DivisorFamilyAffSeedGate.lean`'s composition, `AffCoverData.SwallowedBy`-based producers in `DivisorFamilyAffStraddle.lean`) constructs a concrete cover with `m ≥ 1`, so this tail is not where the vacuity risk sits. **Verdict: SOUND, no vacuous clause.**

### 2. `IsThetaPaired` and `IsChartClause` — mention + inhabitation

**`IsThetaPaired`** (DivisorFamilyAffTheta.lean:570, `thetaSpan A τ a * thetaInvSpan A τ a = 1`): mentions the actual twisted glued submodules — not vacuous in content. But its index `τ : ChartTyping C R π D` (binder at :142) is **empty on straddling covers** (see item 3). I found the project's own fix for this: **`ThetaTrivData`** (DivisorFamilyAffThetaTyping.lean:99), a chart-free re-indexing that is provably inhabited at `a=0` for *every* cover including straddling ones (`AffCoverData.thetaTrivDataZero`, :301, and the separation theorem `nonempty_thetaTrivData_and_isEmpty_chartTyping`, :343). However — I checked specifically — **there is no `TrivThetaPaired`/chart-free analogue of `IsThetaPaired` itself anywhere in the tree** (grepped, zero hits). `ThetaTrivData` re-derives the kernel bridge (`ker_trivGluedEval`, :474) and window carve, but `IsThetaPaired` as a named Prop still only exists on the old, sometimes-empty `ChartTyping` index. So the fix exists one layer down (the module it needs) but hasn't been lifted to the `IsThetaPaired` statement itself.

**`IsChartClause`** (DivRepAffPullClause.lean:119): mentions the actual chart family `U`, the classifier `IsDivRepClassify`, and the real chart map — not vacuous in content, and reduced to a genuine equation-of-morphisms by `isChartClause_iff_forall_classify_eq` (DivRepChartRange.lean:186). Its index is `(i,j) : (glueData k g r1).J × (glueData k g r2).J` — I did not find a proof that this product type is nonempty in the files touched, but I also found **no producer of `IsChartClause` anywhere in the tree** (confirmed by the file's own header, :44: "What this does NOT do. It produces no `IsChartClause`"), so inhabitation-of-the-index is moot — the statement itself is simply unproved (U2, gated on G-4), not silently vacuous.

### 3. `ChartTyping` inhabitation at HEAD — DivisorFamilyAffCover.lean:204

Re-verified fresh (not relying on memory): `isEmpty_chartTyping_of_straddling` is still present at DivisorFamilyAffTheta.lean:658, and its statement is unchanged — for any `D : AffCoverData C R`, a piece `j` with a point outside `V₀` and a point outside `V₁` gives `IsEmpty (ChartTyping C R π D)`. The **sole producer** in the tree remains `FinCoverData.toChartTyping` (DivisorFamilyAffCover.lean:255), which only builds a `ChartTyping` from the *old* fixed-pair `FinCoverData` — so every current instantiation is a re-indexing of the chart-typed layer, never something built directly on a straddling `AffCoverData`.

**New finding since my first pass**: I read `DivisorFamilyAffThetaTyping.lean` in full (I had only grepped it before) — it is exactly the fresh-context repair for this, dated the same day, and it **explicitly documents the emptiness as a defect of the index, not the mathematics** ("the widened Θ-layer's vacuity there is a defect of the index rather than of the layer's mathematics", :339-341). It supplies `ThetaTrivData` as the strictly-wider replacement and proves inhabitation at `a=0` on straddling covers. This is real, verified progress on the emptiness problem — but as noted in item 2, it hasn't yet been carried up to `IsThetaPaired` itself, so **`ChartTyping` remains empty on straddling covers at HEAD**, and every theorem still indexed by literal `ChartTyping` (which includes `IsThetaPaired`) remains vacuous there. The fix is one file away from closing the gap, not yet applied to the specific declaration you're asking about.

**Confirms your two independent findings** — I have no contradicting evidence for either; both check out against my own reading (`isChartUniv_of_isChartLocusFibre`'s "the open V is arbitrary" docstring, and the coupling gap documented in `Pic0ChartAtlasCoupling.lean`, which I read in full and is consistent with your PEmpty/bottom-sieve argument).
