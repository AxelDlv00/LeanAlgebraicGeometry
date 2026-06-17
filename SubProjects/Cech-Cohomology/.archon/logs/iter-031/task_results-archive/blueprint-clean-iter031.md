# blueprint-clean — iter-031 report

**Chapter:** `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

## Findings and fixes applied

### 1. Lean name leakage — proof prose (FIXED)

**Location:** `lem:qcoh_iso_tilde_sections_of_presentation` proof, lines ~3703–3704.

The proof body contained the bare Lean declaration name
`\(\operatorname{isIso\_fromTilde\Gamma\_of\_presentation}\)` (with underscores) immediately
before the `\ref{}` cross-reference that replaces it.

**Fix:** Removed the redundant Lean name; the existing
`(Lemma~\ref{lem:isIso_fromTildeGamma_of_presentation})` reference is now the sole pointer.

---

### 2. Lean dotted-name leakage — proof prose (FIXED)

**Location:** `lem:qcoh_localized_sections` proof, lines ~3907–3908.

The proof cited the Mathlib internal dotted name `\(\operatorname{tilde.toOpen}\)` in running
prose to name the localisation instance.

**Fix:** Replaced the parenthetical `(\texttt{lemma-widetilde-pullback}: …, the Mathlib
\(\operatorname{tilde.toOpen}\) localisation instance)` with the purely mathematical
`(by \texttt{lemma-widetilde-pullback}: \(\Gamma(D(g), \widetilde{M}) = M_g\))`.

---

### 3. Lean name leakage — statement prose (FIXED)

**Location:** `lem:free_isQuasicoherent` statement, lines ~3824–3825.

The final sentence referred to the Mathlib-internal name `\(\operatorname{tildeFinsupp}\)` as a
parenthetical.

**Fix:** Replaced with the mathematical paraphrase "obtained from the identification of the free
\(\mathcal{O}_X\)-module with the tilde of the free \(R\)-module."

---

### 4. SOURCE QUOTE verbatim inconsistency (FIXED)

**Location:** `lem:exists_finite_basicOpen_subcover`, first `% SOURCE QUOTE` block,
line ~3834.

The quote excerpts two consecutive `\item`-tagged list items from `lemma-standard-open`
(Stacks, L531–534). The first item's `\item` prefix was dropped while the second retained it,
yielding an inconsistent verbatim quote.

**Fix:** Added `\item ` before the opening word of the first quoted item so both list entries
are prefixed consistently, matching the source.

---

### 5. SOURCE QUOTE truncation without ellipsis (FIXED)

**Location:** `lem:qcoh_global_generation`, `% SOURCE QUOTE` in proof, line ~3930.

The quote of `lemma-quasi-coherent-affine` (proof, L1366–1373) ended at
`to a section $s_i \in \mathcal{F}(U_i)$."` but the Stacks source continues on the same
sentence with `(Namely, $\varphi^{-1}_i(m_i)$.)` without any ellipsis to signal omission.

**Fix:** Appended the missing parenthetical so the quote is verbatim to the end of the
sentence: `… to a section $s_i \in \mathcal{F}(U_i)$. (Namely, $\varphi^{-1}_i(m_i)$.)"`

---

## Source quote verification — all P0–P4 blocks

Each lemma's `% SOURCE QUOTE` was checked verbatim against `references/stacks-schemes.tex`:

| Block | Source tag | Result |
|---|---|---|
| `lem:qcoh_iso_tilde_sections` | `lemma-spec-sheaves` L693–702 | ✓ verbatim (items 1–4 + closing tag) |
| `lem:qcoh_iso_tilde_sections_of_presentation` | `lemma-quasi-coherent-affine` L1280–1284 | ✓ verbatim |
| `rem:o1i8_decomposition` | `lemma-quasi-coherent-affine` proof L1288–1386 | ✓ verbatim with ellipsis |
| `lem:free_isQuasicoherent` | `lemma-colimit-quasi-coherent` L1437–1438 | ✓ verbatim |
| `lem:exists_finite_basicOpen_subcover` (1st quote) | `lemma-standard-open` L531–534 | ✓ after fix 4 |
| `lem:exists_finite_basicOpen_subcover` (2nd quote) | `lemma-quasi-coherent-affine` proof L1289–1300 | ✓ verbatim with ellipsis |
| `lem:qcoh_localized_sections` (1st quote) | `lemma-widetilde-pullback` proof L1262–1268 | ✓ verbatim |
| `lem:qcoh_localized_sections` (2nd quote) | Stacks remark L1272–1276 | ✓ verbatim |
| `lem:qcoh_global_generation` | `lemma-quasi-coherent-affine` proof L1366–1373 | ✓ after fix 5 |
| `lem:tilde_preserves_kernels` | `lemma-kernel-cokernel-quasi-coherent` proof L1426–1431 | ✓ verbatim |
| `lem:qcoh_kernel_qcoh` | `lemma-kernel-cokernel-quasi-coherent` L1420–1422 | ✓ verbatim |
| `lem:isIso_fromTildeGamma_of_quasicoherent` | `lemma-quasi-coherent-affine` L1280–1284 | ✓ verbatim |

---

## \uses{} validation

All labels referenced in `\uses{}` blocks in the new blocks are defined in the chapter:

`lem:free_isQuasicoherent`, `lem:exists_finite_basicOpen_subcover`, `lem:qcoh_localized_sections`,
`lem:qcoh_global_generation`, `lem:tilde_preserves_kernels`, `lem:qcoh_kernel_qcoh`,
`lem:isIso_fromTildeGamma_of_genSections`, `lem:qcoh_iso_tilde_sections_of_genSections`,
`lem:isIso_fromTildeGamma_of_quasicoherent`, `lem:qcoh_iso_tilde_sections`,
`lem:qcoh_iso_tilde_sections_of_presentation`, `lem:isIso_fromTildeGamma_of_presentation`,
`def:standard_affine_cover`, `def:basis_cov_system`, `def:has_vanishing_higher_cech`,
`lem:affine_faces_mem`, `lem:affine_surj_of_vanishing`, `lem:injective_cech_acyclic`.

No broken `\uses{}` references found.

---

## Items not touched

- `\leanok` markers — untouched (sync-owned).
- `\mathlibok` markers — untouched.
- `% NOTE:` annotations — untouched.
- Mathematical content and structure of the P0–P4 chain — untouched.
- Pre-existing `\operatorname{IsLocalizedModule}` / `\operatorname{fromTildeΓ}` /
  `\operatorname{IsIso}` notation in the existing (pre-iter-031) blocks — these are
  established document style and were not disturbed.
