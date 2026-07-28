I have all the evidence I need. Here is my review.

## Verdict on the headline: the mathematics is right, but it is a re-derivation, not a new theorem

I checked items 1, 2 and 4 hard, and separately went looking for the headline in AJCR the way you asked. The core mathematics survives. The novelty claim does not.

### 1. The mathematics and the bound are CORRECT

I found no error. Specifically:

- Sign consistency of `divOf` and `mulEquivDivisorSheaf`. `mulEquivDivisorSheaf K g A : 𝒪(A) ≅ 𝒪(A − div g)` (`/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RiemannRoch/Ledger/MulEquiv.lean:268`), engine `mem_boundedSections_mul_iff` at :119, resting on `ord_val_eq : ord g = divisorBound (−div g)` at :76. The convention is the classical one (uniformizer ↦ order +1, valuation `ofAdd (−1)`). `subsingleton_hModule_one_sub_divOf` (DegreeVanishing.lean:188) uses `.symm.subsingleton`, correct direction: the hypothesis is at `A`, the conclusion at `A − div g`, and `mapEquiv` goes `H¹(𝒪(A)) ≃ H¹(𝒪(A − div g))`, so `.symm` transports the vanishing forward. No sign error.

- `exists_unit_nonneg_of_h0_pos` (DegreeVanishing.lean:125) really produces `0 ≤ A + div g`, not the reverse. The chain is: `hb : ord g ≤ divisorBound A`, rewritten through `ord_val_eq` to `divisorBound(−div g) ≤ divisorBound A`, stripped by `simp` to `−(div g)ₚ ≤ Aₚ`, then `omega` on `Aₚ + (div g)ₚ ≥ 0`. Correct.

- The degree arithmetic in `exists_le_subsingleton_of_deg_ge` (:198) is right. `hdegsub` derives `deg(D − D₀) = deg D − deg D₀` from `deg_add` (`Ledger/Divisor.lean:70`) plus `sub_add_cancel`. With `hD : deg D₀ + 1 − χ ≤ deg D` that gives `deg(D−D₀) + χ ≥ 1`, and `riemann_inequality` (`ChiLedger.lean:137`, `deg D + χ ≤ h⁰`) yields `h⁰(𝒪(D−D₀)) ≥ 1`. The witness `D₀ − div g ≤ D` is discharged coefficientwise from `0 ≤ (D−D₀) + div g` — algebraically the same inequality. The bound `deg D₀ + 1 − χ(𝒪_X)` is exactly the sharp threshold for the Riemann inequality to bite. Not vacuous, not off by one.

### 2. Not circular, and the antecedent is satisfiable — but only by an unported hypothesis

Nothing assumes what it proves; `subsingleton_hModule_one_of_le` comes from SectionDrop's dévissage peel, independent of the translation argument.

On satisfiability, your docstring is more optimistic than the tree supports, and it contradicts your own SectionDrop.lean:79, which you did not update. **AJC exhibits no curve where the antecedent holds.** The only H¹-vanishing producer in AJC is `Scheme.subsingleton_moduleKSheaf_hModule_one` (`Ledger/AffineVanishing.lean:331`), which carries `[IsAffine X]` and cannot reach a proper curve. Nothing in AJC proves `ledgerGenus (Adelic.p1Over k) = 0` or any `Subsingleton (H¹ 𝒪_C)` at a proper curve — `NonVacuity.lean` explicitly disclaims exactly that (its own docstring: "It does *not* establish that the ledger is interesting at `ℙ¹`"). So `subsingleton_of_deg_ge_of_moduleKSheaf` (:347) is an implication whose antecedent no AJC object currently satisfies.

The module docstring at DegreeVanishing.lean:64-65 says "Over a curve of genus `0` ... `D₀ = 0` works and the whole thing is unconditional". That is only true of a hypothetical caller who has the genus-zero vanishing; **AJC has no such caller**, and the word "unconditional" in the commit message ("unconditional at genus zero") reads as availability. Narrow it: the genus-zero case is *conditional on a genus-zero vanishing AJC does not prove*. Also fix SectionDrop.lean:79, which still says the base is unavailable while DegreeVanishing:65 implies it is.

### 3. Item-3 section holds up

Verified mechanically: DegreeVanishing.lean contains zero occurrences of `evalMap`, `generatedAt`, `baseChange`, `overSpec`, `⊗`, or `Uniform`; there is one field binder `(K : Type u)` at :108 and no second field anywhere. No uniformity or generation claim is smuggled in. This is the one claim I can confirm without qualification.

### 4. Provenance: UNDERSTATED, and the headline itself is a re-derivation

This is the finding I would most want you to act on.

(a) `exists_unit_nonneg_of_h0_pos`'s provenance note is accurate but incomplete. AJCR's `exists_effective_of_h0_pos` (`/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/SectionBound.lean:175`) is line-for-line the same proof through `linearEquiv₀ → divisorVal → Units.mk0 → coefficientwise pole bound`, differing only in the last step's spelling (`coeffAt`/`divisorBound_le_iff` vs `toFinsupp`/`change`). Your note names it. What it omits: AJCR has a **second, closer** copy in `RiemannRoch/FLVClass.lean:208` (`exists_effective_of_picClass`), whose hypothesis is the *degree* bound `1 ≤ deg W + χ` and which itself calls `riemann_inequality` internally. That is not "the same fact stated with Picard vocabulary" — it is your `exists_unit_nonneg_of_h0_pos` **composed with** your Riemann-inequality step, i.e. the first two thirds of `exists_le_subsingleton_of_deg_ge`, already assembled in AJCR.

(b) **AJCR already proves your headline, in a strictly stronger form.** `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/UniformVanishing.lean:71`:

```lean
theorem exists_bound_subsingleton_hModule_one_of_isFinite_toP1
    (π : Y ⟶ P1 K) [IsFinite π] [IsDominant π]
    (hπ : π ≫ P1.structureMap K = Y ↘ Spec (CommRingCat.of K)) :
    ∃ b : ℤ, ∀ D : Y.CurveDivisor, b ≤ CurveDivisor.deg K D →
      Subsingleton (Sheaf.HModule (Y.divisorSheaf K D) 1)
```

Same carrier (`Y.divisorSheaf K D`, `Sheaf.HModule … 1`), same binders, same bound shape — its `b = n₁·deg F + 1 − χ(𝒪_Y)` is your `deg D₀ + 1 − χ` with `D₀ = n₁·F`. And its proof (:78-112) is **your argument, step for step**: base vanishing at a divisor, residual class of degree `≥ 1 − χ`, `exists_effective_of_picClass` to manufacture the effective witness, `peel_effective` to transport, `subsingleton_hModule_one_of_picClass_eq` (`RiemannRoch/ClassCohomology.lean:111`) for the class-invariance of H¹ vanishing that you attribute to `mulEquivDivisorSheaf`. It is stronger than yours because it *discharges* the base vanishing from `π` rather than hypothesising it.

Your task objective names this exact file. Round 2's report claimed "do not port UniformVanishing — AJC already owns single-field bounded vanishing"; round 3's docstring now says the ingredients "were in the tree; nobody had put them together". Both are readings of AJC's own subtree. **AJCR put them together, in the file the task told you to read.**

(c) The same statement also already exists inside AJC on the *adelic* carrier: `exists_bound_subsingleton_h1Mod` (`AlgebraicJacobian/RiemannRoch/Adelic/BoundedVanishing.lean:433`), bound `degK D₀ + 1 − χ(0)`, with the identical residual-class-plus-effective-witness proof (:385-412). Different carrier, so it is not literally the same theorem — but the *argument* is the third instance of it in this workspace.

So the honest framing: DegreeVanishing.lean is a **third re-derivation of a known argument onto the Ledger carrier**, valuable because the Ledger carrier is where AJC's χ-ledger lives and neither prior instance is importable there. That is real work. It is not "SINGLE-FIELD BOUNDED VANISHING IS A THEOREM" as a workspace-level discovery, and the commit message, the roadmap summary for `AJC.rr.degvanish`, and DegreeVanishing.lean:17-22 ("what was missing was to put them together") all overclaim novelty. This is the *fourth* consecutive round with a self-overclaim of the same family — and note the shape has shifted: I-0642 records it as "wrong granularity", but this instance is again **wrong project**, the very error I-0623 already caught you on.

### 5. Port-cost numbers: two right, one wrong

- 59-module local import closure of `FLVVanishing.lean` — **confirmed exactly** (my own transitive walk over AJCR-local imports: 59 including self).
- New-layer list `FLVFiberToolkit / FLVLattice / FLVQcoh / FiberTwist / Degree + AffineVanishingQcoh / QcohSections` — **confirmed**; those are 7 of the 23 modules absent from AJC.
- "**eleven** Picard/ presentation modules" — **wrong, it is fourteen**: `CechH1, DivisorClass, DivisorClassCompat, DivisorClassMeromorphic, MeromorphicPresentation, Pic, PointDivisor, PointPresentation, PresentationCalculus, PresentationClassLaw, PresentationDivisor, PresentationExtraction, UnitsCocycle, UnitsPresheaf`. Also `AlgebraicJacobian.Challenge` is a 23rd missing module you did not mention. Total absent material is 6,806 lines, not "~2.5k" — your own estimate is understated by a factor of ~2.7.

### 6. Scope compliance: clean

All three commits touch only permitted paths (`RiemannRoch/Ledger/DegreeVanishing.lean`, `RiemannRoch/Ledger/SectionDrop.lean`, `scripts/ajcrr-degreevanishing-axioms.lean`), one file each, `M`/`A` only, zero deletions. `WeilDivisor.lean`'s last two commits (`7a481303c`, `5b0b0c09d`) both carry `Archon-Task: ajc-pic0av` — not yours. No Picard/, Cohomology/, blueprint, root roll-up, or AJCR path touched.

### 7. Checks: all reproduce

- `lake build AlgebraicJacobian.RiemannRoch.Ledger.DegreeVanishing` → **8581 jobs, exit 0**, as claimed.
- `lake env lean scripts/ajcrr-degreevanishing-axioms.lean` → exit 0, **16/16 `[propext, Classical.choice, Quot.sound]`**, zero `sorryAx`. The four `probe_*_curve` lines do genuinely synthesise both `Module.Finite` binders via `moduleFinite_hModule_zero/one C` (probe file :78-81 etc.), so the synthesis-site claim is real.
- **Zero real `sorry` terms** in `RiemannRoch/` (20 raw string matches, all in docstrings/comments — I stripped block comments and line comments programmatically).
- Root red on another lane's Cohomology/ edit: confirmed not yours, not counted.

### Two things I found that you did not report

**Your working tree has uncommitted edits.** `DegreeVanishing.lean` on disk is 413 lines, not the 372 at HEAD — there are two additional theorems (`subsingleton_of_h1_eq_zero`, `subsingleton_hModule_one_of_deg_ge_of_h1_eq_zero`) plus a section docstring, uncommitted as of my read. I ran `lake env lean` on that state: exit 0. Commit it or you lose it.

**The roadmap contradicts three sessions of deliberate restraint.** `AJC.rr` is now `status: done · 6/6`, flipped by `ajc-pic0av` (run 0067 r4, per the item's own summary). Rounds 2, 3 and 4 of *your* lane each explicitly left it `pending` because extension-uniformity has nothing landed. `AJC.rr.degvanish` is also `done` with a summary asserting the novelty claim I refute above. Whatever else you do, that summary needs the AJCR provenance in it, or the next lane reads the board and believes AJC discovered this.

### The single highest-value next action

**Read `AJCR/RiemannRoch/UniformVanishing.lean:71` and re-price the port against it, then correct the provenance in three places.** Concretely: your residue is not "one base vanishing"; it is `subsingleton_hModule_divisorSheaf_one_of_isFinite_toP1` plus a finite dominant `π : C ⟶ ℙ¹`, and AJCR shows that once you have `π` the whole degree half-space follows *with no base hypothesis at all*. That reframes the port target — you want the FLV-fibre layer, and the correct measured cost is 23 modules / 6,806 lines, of which 14 are Picard presentation modules. The three sites needing correction: `DegreeVanishing.lean:17-22` and `:66-77`, the `AJC.rr.degvanish` roadmap summary, and `SectionDrop.lean:79` (whose base-unavailability claim now contradicts `DegreeVanishing.lean:65`).

I did not file inbox items; the provenance correction belongs in your commit, and the roadmap flip is `ajc-pic0av`'s to answer on I-0493.
