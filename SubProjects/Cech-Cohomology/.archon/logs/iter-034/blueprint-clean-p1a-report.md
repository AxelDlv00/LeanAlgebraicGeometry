# Blueprint-clean report — iter-034 P1a

## Changes made

### 1. Removed project-history header comment block
Deleted the 14-line `% ===========================================================================` block
preceding `lem:modules_restrict_basicOpen` that referred to "effort-breaker, iter-034",
"absent-from-Mathlib infrastructure steps", "L1/L2/L3" internal labels, and the "assembled top
lemma" framing. Timeless math document does not require this scaffolding.

### 2. `lem:modules_restrict_basicOpen` — stripped `% NOTE:` block
Removed 8-line `% NOTE:` comment containing:
- Lean declaration names `modulesRestrictBasicOpen`, `modulesRestrictBasicOpenIso`
- Lean-specific language: "absent-from-Mathlib geometry primitive of P1a", "(Spec R).Modules object"
- Marker-management prose: "it is left unmarked here rather than `\mathlibok`"

Also corrected the `% SOURCE:` line range from `L1262--1276` to `L1241--1276`
(the lemma `lemma-widetilde-pullback` opens at line 1241; 1262 was mid-proof).

### 3. `lem:tilde_restrict_basicOpen` — stripped `% NOTE:` block
Removed 4-line `% NOTE:` comment containing:
- "absent from Mathlib in this packaged form and is project-to-build"
- Duplicate of `\uses{}` dependency reasoning

### 4. `lem:presentation_restrict_basicOpen` — stripped `% NOTE:` block
Removed 5-line `% NOTE:` comment containing:
- "absent from Mathlib for (Spec R).Modules and is project-to-build"
- Lean typeclass name `IsQuasicoherent`
- Duplicate of `\uses{}` dependency reasoning

### 5. `lem:isQuasicoherent_restrict_basicOpen` — stripped `% NOTE:` block
Removed 6-line `% NOTE:` comment containing:
- Project-history labels: "assembled top lemma of P1a", "L1--L3", "P1b"
- "pure-algebra companion of the P1 decomposition"
- Duplicate of `\uses{}` content

## Source quote verification

All four blocks retain their `% SOURCE:`, `% SOURCE QUOTE:`, and (where present)
`% SOURCE QUOTE PROOF:` comments. Each was checked against
`references/stacks-schemes.tex`:

| Block | Source loc | Quote | Status |
|---|---|---|---|
| `lem:modules_restrict_basicOpen` | L1272–1276 remark | "Lemma \ref{lemma-widetilde-pullback} above says in particular…" | ✓ verbatim |
| `lem:tilde_restrict_basicOpen` | L1253–1254 (stmt) | "\item We have $\psi_* \widetilde N = \widetilde{N_R}$ functorially in the $S$-module $N$." | ✓ verbatim |
| `lem:tilde_restrict_basicOpen` | L1262–1268 (proof) | "The second assertion follows from the fact that $\psi^{-1}(D(f))…$ as desired." | ✓ verbatim (display eq inlined in comment) |
| `lem:presentation_restrict_basicOpen` | L1294–1300 | "for every prime $\mathfrak p \subset R$…covering to  a standard open covering." | ✓ verbatim (double space preserved) |
| `lem:isQuasicoherent_restrict_basicOpen` | L1298–1303 | "In other words, we get an open covering…for some $R_{f_i}$-module $M_i$." | ✓ verbatim |

## Out-of-scope blocks
`lem:toSheaf_preservesFiniteColimits`, `lem:to_sheaf_preserves_epi`,
`lem:affine_surj_of_vanishing`, `def:affine_cover_system`, `lem:tilde_preserves_kernels`
— not touched.

## `\leanok` / `\mathlibok`
Not added or removed (per directive).
