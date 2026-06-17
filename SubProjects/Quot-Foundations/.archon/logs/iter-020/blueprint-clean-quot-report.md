# Blueprint Clean Report — quot (iter-020)

**Target:** `blueprint/src/chapters/Picard_QuotScheme.tex`

## Summary

Purity pass completed. All edits are in the newly added blocks from the blueprint-writer round. No `\lean{}`, `\label{}`, `\uses{}`, or `\mathlibok` were added or removed. No `\leanok` was touched.

---

## Changes Made

### 1. NOTE block in `lem:graded_subquotient_degreewise_diff` (was lines 1477–1482)

**Issue:** Lean source identifiers used as prose: backtick-quoted `finrank_comap_subtype`, Lean type-ascription syntax `(p S : Submodule κ M)`, Lean terms `finrank κ ↥(S.comap p.subtype)` and `finrank κ ↥(p ⊓ S)`, and the Lean keyword `private`.

**Fix:** Replaced the note body with a purely mathematical description:
> "The proof factors the two kernel-dimension computations through a helper that identifies the dimension of the preimage of a submodule under the inclusion of an ambient submodule with the dimension of their ambient intersection. This helper is an implementation detail and carries no public blueprint node."

---

### 2. `def:graded_lastVarAlgHom` body prose (was lines 1716–1731)

**Issues (multiple):**
- `\(\mathrm{Fin.last}\,r\)` — Lean type name used as prose.
- `\(X_{\,\mathrm{castSucc}\,i}\)` — Lean `Fin.castSucc` used as index notation.
- Parenthetical clusters `(\(\mathrm{lastVarAlgHom}_{X_{\mathrm{castSucc}}}\), \(\mathrm{lastVarAlgHom}_{X_{\mathrm{last}}}\), \(\mathrm{lastVarAlgHom}_C\))`, `(\(\mathrm{lastVarAlgHom}_{\mathrm{rename}\,\mathrm{castSucc}}\))`, `(\(\mathrm{lastVarAlgHom}_{\mathrm{surjective}}\), ...)` — Lean lemma names as prose (these are already covered by the `\lean{}` pins).
- `\(\mathrm{RingHomSurjective}\)` — Lean typeclass name.
- Last sentence about Lean implementation: "built with multivariate evaluation, the \(\mathrm{Fin}\) last-case recursor, and the variable-renaming map of \(\operatorname{MvPolynomial}\)" — Lean construction detail.

**Fix:** Replaced with clean mathematical prose:
> "obtained by evaluation: it sends the last variable \(X_r\) to \(0\) and each earlier variable \(X_i\) (for \(0 \le i < r\)) to \(X_i\), and fixes constants. It is a left inverse of the algebra map \(\kappa[t_0, \dots, t_{r-1}] \to \kappa[t_0, \dots, t_r]\) induced by the canonical inclusion \(\{0, \dots, r-1\} \hookrightarrow \{0, \dots, r\}\) on variable indices, and is therefore surjective. This is the concrete ring surjection … along which finiteness is transferred."

---

### 3. `lem:graded_polyEndHom_lastVar_sub_mem` — formula and prose (was lines 1762–1774)

**Issues:**
- `\mathrm{polyEndHom}(t \circ \mathrm{castSucc})` in the displayed formula — `castSucc` is a Lean `Fin` function.
- `t \circ \mathrm{castSucc}` in prose.
- `s = X_{\,\mathrm{castSucc}\,i}` in the proof-description.
- `(\(\mathrm{Fin.last}\))` parenthetical next to `s = X_{\,r}`.

**Fix:**
- Formula: replaced `\mathrm{polyEndHom}(t \circ \mathrm{castSucc})` with `\mathrm{polyEndHom}(t_0, \dots, t_{r-1})`.
- Prose: replaced `t \circ \mathrm{castSucc}` with `(t_0, \dots, t_{r-1})`.
- Proof description: replaced the `castSucc`-indexed case and `Fin.last` parenthetical with: "the case of an earlier variable \(s = X_i\) (\(i < r\)) is the inductive hypothesis after \(\mathrm{lastVarAlgHom}\) fixes it; the case of the last variable \(s = X_r\) annihilates the reduced term."

---

### 4. `lem:graded_subquotient_finite_transfer` — statement and proof (was lines 1839–1840, 1857)

**Issues:**
- Statement: `t \circ \mathrm{castSucc} = (t_0, \dots, t_{r-1})`.
- Proof: `X_{\,\mathrm{castSucc}\,i}`.

**Fix:**
- Statement: "the reduced family \((t_0, \dots, t_{r-1})\)" (removed `t \circ \mathrm{castSucc} =` prefix).
- Proof: "each earlier variable \(X_i\) (\(i < r\))".

---

### 5. `def:graded_subquotientDatum_ker` body (was line 1940)

**Issue:** `t \circ \mathrm{castSucc} = (t_0, \dots, t_{r-1})` in "on the reduced family …".

**Fix:** "on the reduced family \((t_0, \dots, t_{r-1})\)".

---

### 6. Finiteness-field references (`hfin`) — 3 sites

**Issue:** `\(\mathrm{hfin}\)` is the Lean field name of `SubquotientDatum`. Appeared in:
- `lem:graded_polyQuot_finite_of_le_numerator`: "the \(\mathrm{hfin}\) field of the kernel constructor"
- `lem:graded_polyQuot_finite_of_le_denominator`: "the \(\mathrm{hfin}\) field of the cokernel constructor"
- `def:graded_subquotientDatum_ker`: "The finiteness field \(\mathrm{hfin}\) is obtained by…"

**Fix:** Replaced all three with "finiteness witness".

---

### 7. NOTE blocks in `lem:graded_subquotient_base_eventuallyZero` proof (was lines 2123–2133)

**Issues:**
- Route (b) note: "ROUTE (b) -- USE THIS" (prover framing); `Submodule.mem_iSup_iff_exists_dfinsupp` (Lean identifier in prose); "This is the working route." (prover framing).
- Route (a) note: "ROUTE (a) -- DEAD END, do not retry" (prover framing); `Submodule.liftQ FAILS:` (Lean identifier + prover framing); `liftQ over the MvPolynomial(∅,κ)-quotient produces an MvPolynomial(∅,κ)-(semi)linear map` (Lean syntax in prose); "The mathematics is correct but the construction does not typecheck;" (prover framing).

**Fix:** Stripped all prover/iter framing; replaced Lean identifiers with mathematical descriptions; kept the route (a)/(b) distinction as a concise mathematical remark:
> Route (b): prove iSupIndep by direct membership analysis in ⨆_{j≠n} range(ψ j), reading off the degree-n component directly inside Q₀.
> Route (a): descent through the subquotient fails due to a scalar-ring incompatibility between Q₀'s base ring and the κ-module structure on the target M/N'.

---

## Citation Discipline Check

All blocks citing `references/hilbert-serre-algebra.tex` were verified verbatim against the source file:

| Block | Cited lines | STATUS |
|---|---|---|
| `lem:gradedHilbertSerre_rational` (statement) | L13893–L13905 | ✓ verbatim |
| `lem:gradedHilbertSerre_rational` (proof) | L13938–L13947 | ✓ verbatim |
| `lem:graded_subquotient_degreewise_diff` (proof) | L13939–L13947 | ✓ verbatim |
| `lem:graded_subquotient_base_eventuallyZero` (statement) | L13908–L13910 | ✓ verbatim |
| `lem:graded_subquotient_isRatHilb` (proof) | L13908–L13914 | ✓ verbatim |

No missing `% SOURCE QUOTE` blocks were found. No reference retriever spawn was required.

---

## Preserved (unchanged)

- All `\lean{}`, `\label{}`, `\uses{}`, `\mathlibok` markers: unchanged.
- All `\leanok` markers: unchanged.
- Mathematical content of route (a)/(b) distinction: preserved as a concise mathematical remark.
- All source quote comment blocks: preserved verbatim.
- All other chapters: untouched.
