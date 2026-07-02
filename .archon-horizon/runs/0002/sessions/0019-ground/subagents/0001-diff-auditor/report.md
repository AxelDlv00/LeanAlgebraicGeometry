Audit complete. All four points check out; no blocking problems found. Returning a written summary (nothing warrants an inbox issue — findings are clean or minor pre-existing clutter).

---

## Diff audit: Albanese Horizon round (StandardSmoothDimension + §3.B Stacks 00TT closed-point)

Diff scope confirmed: 4 files only — `AlgebraicJacobian.lean` (+1 import), `AlgebraicJacobian/Albanese/CodimOneExtension.lean` (+219/-65), `AlgebraicJacobian/Albanese/StandardSmoothDimension.lean` (+215 new), `blueprint/.../Albanese_CodimOneExtension.tex`. The blueprint anchor edits point at the freshly-added declarations in this same project — expected Ground reconciliation, not a stray writer.

### 1. Sorries / admit / native_decide / axiom — CLEAN
- New module `StandardSmoothDimension.lean`: **zero** `sorry`/`admit`/`native_decide`/`axiom`. All four theorems have full bodies.
- `CodimOneExtension.lean`: 3 code sorries at L1563, L1760, L1835 — all **pre-existing and unchanged**. The only `+` lines in the diff mentioning "sorry" (docstring L~35, L~158) are prose, not code. No signature was weakened: every removed (`-`) line is docstring/comment prose; no theorem signature was deleted or relaxed.
- Project-wide code-sorry count = **16** (FGAPicRepresentability 2, Thm32RationalMapExtension 2, GmScaling 1, WeilDivisor 1, AlbaneseUP 7, CodimOneExtension 3), matching the report exactly.

### 2. Stray files — none from this round
Present in project root: `SubProjects/Albanese/RationalCurveIso.{body,new,skeletal}` and `SubProjects/Albanese/TO_USER.md`. All dated **Jun 17** — pre-existing, already recorded in memory (`albanese-stray-blueprint-fragments`), and outside this diff (which touches only the 4 files above). No new scratch/tmp/.orig/.bak files introduced; workspace root is clean.

### 3. Sound reasoning — coherent, non-vacuous
- `MvPolynomial.height_eq_natCard_of_isMaximal` (L72): induction via `Finite.induction_empty_option`; base = field (Krull dim 0), option-step contracts along `C` using Jacobson (`Polynomial.isMaximal_comap_C_of_isJacobsonRing`) + `Polynomial.height_eq_height_add_one`. Not circular.
- `natCast_le_height_of_isMaximal` (L126): pullback `M` of `m` to `P.Ring` is maximal of full height `#ι`; kernel = span of `#σ` relations (`spanFinrank ≤ #σ`); Krull's height theorem `height_le_height_add_spanFinrank_of_le` gives `#ι ≤ ht m + #σ`; with `n + #σ = #ι` yields `n ≤ ht m`. Statement matches name.
- Localised form + regularity glue (`of_finrank_cotangentSpace_le_ringKrullDim`) are straightforward reductions. No `False`-elim, no vacuous hypotheses.
- §3.B `..._of_bijective_residue` (L41): combines (ii.A) `finrank κ(m/m²) = n` with (ii.B) `n ≤ ringKrullDim Sₘ` through the glue — mathematically the correct `finrank = n ≤ dim ⟹ regular` step. `..._of_isAlgClosed` (B.d′) discharges the bijectivity hypothesis via Zariski's lemma. The report is honest that the residual `isRegularLocalRing_stalk_of_smooth` sorry is the genuinely-different non-closed-point case (Stacks 00OF) — no hypothesis fudging.
- **Kernel-built**: `.lake/build/lib/lean/AlgebraicJacobian/Albanese/StandardSmoothDimension.olean` dated Jul 2 10:58 (this round), confirming the module elaborates (built green).

### 4. Duplication concern — confirmed, dead code, no clash
The old iter-200 private lemmas exist at:
- L647 `MvPolynomial.maximalIdeal_height_ge_card_of_field`
- L666 `MvPolynomial.maximalIdeal_height_le_natCard_of_field`
- L676 `MvPolynomial.maximalIdeal_height_eq_card`
- L692 `MvPolynomial.maximalIdeal_height_eq_natCard`

They are semantically subsumed by the new public `MvPolynomial.height_eq_natCard_of_isMaximal`.
- **No name clash**: the old ones are `private` and carry distinct names (`maximalIdeal_height_*`) from the public `height_eq_natCard_of_isMaximal`, even though both sit in namespace `MvPolynomial`.
- **They are dead code**: the only consumer chain is `...eq_natCard` → `ringKrullDim_localization_atMaximal_MvPolynomial` (L723) → `ringKrullDim_quotient_localization_MvPolynomial_of_regular` (L871), and L871 is **referenced nowhere**. So the whole L647–714 / L723 / L871 block (~250 LOC) is orphaned. Harmless (Lean does not warn on unused private theorems) but clutter. This block was **untouched by this diff** (pre-existing), so it's not a regression from this round.

### Recommendation
Nothing blocking; no inbox issue warranted. Two low-priority hygiene items worth a memory note for a future janitor pass: (a) the ~250 LOC dead private `MvPolynomial.maximalIdeal_height_*` chain in `CodimOneExtension.lean` L647–871 now superseded by `StandardSmoothDimension.lean`, and (b) the still-present Jun-17 stray fragments (already in memory). The round itself is sound and honestly reported.
