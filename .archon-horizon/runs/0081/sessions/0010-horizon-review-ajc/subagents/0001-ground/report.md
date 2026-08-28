All three confirmed absent from AJC — the roadmap rows correctly attribute them to AJCR, so these are not stale, just cross-project citations (correctly labeled as such in the summaries).

## Report: AJC roadmap citation audit at HEAD

I checked every mechanically-checkable citation (FILE:LINE anchors and backticked Lean declaration names) in the 207 `AJC.*` roadmap rows against the Lean source at HEAD, in both AJC and (where cited) the sibling AJCR tree.

**Result: every single citation checked out true.** No stale anchors, no absent declarations. This is a much cleaner result than the earlier stale-citation problem the launching task's briefing anticipated (the caution about docstring-vs-declaration mismatches, off-by-hundreds-of-lines anchors) — that class of error does not appear in the current `AJC.*` set. The project has clearly been through recent citation-repair passes (multiple rows explicitly say "ANCHOR CORRECTED", "re-grepped at HEAD", "STATUS AND ANCHOR CORRECTED by review-ajc 2026-07-29").

### FILE:LINE anchors (33 checked, 0 stale)

| Roadmap ID | Anchor | Verdict |
|---|---|---|
| AJC.jacobian.assembly.picrep-input, AJC.picrep.assembly | Picard/FGAPicRepresentability.lean:347 | TRUE — inside the "why sheafifying" docstring section, correctly described as prose context for the sorry, not claimed as a declaration line |
| AJC.maintenance.blueprint.pins.remaining-contracts | Cohomology/AffineSerreVanishing.lean:121 | TRUE — `theorem toSheaf_preservesFiniteColimits.{v',u',w'}` head, exactly as described (universe-suffix scanner false negative) |
| AJC.pic0av | Pic0AbelianVariety.lean:853 | TRUE — inside `sorry`-adjacent statement (`semilinearComparison_cotangentSpaceDual_h1Cok`) |
| AJC.pic0av.albanese-et | Jacobian.lean:576 | TRUE — `theorem isAlbanese_pic0Et` body area (decl head at :653, cited as "bare sorry" — sorry confirmed at :660) |
| AJC.pic0av.albanese-et | Jacobian.lean:713-716 | TRUE — "obligations are five" prose, exact text present |
| AJC.pic0av.identity | Genus.lean:41 | TRUE — `def genus` head |
| AJC.pic0av.identity | IdentityComponent.lean:866 | TRUE — `private theorem identityComponent_irreducibleSpace_of_isAlgClosed` head |
| AJC.pic0av.structure | Pic0AbelianVariety.lean:1135 | TRUE — `geometricallyReduced` sorry at :1135 area (sorry line 1136... adjacent) |
| AJC.pic0av.structure | Picard/Pic0Et.lean:174 | TRUE — `theorem geometricallyReduced` head, sorry-bodied |
| AJC.pic0av.structure | Picard/GroupSchemeSmoothAlgClosed.lean:156 | TRUE — inside `smooth_of_grpObj_of_isReduced_algebraicClosureBaseChange` docstring |
| AJC.pic0av.structure | Pic0AbelianVariety.lean:1209-1213 | TRUE — the import-trap lesson text present verbatim |
| AJC.pic0av.tangent | Jacobian.lean:418-421 | TRUE — the "these are those statements" transition prose |
| AJC.picrep | Picard/PicEtSubcanonical.lean:427, :263 | TRUE — both declaration heads exact |
| AJC.picrep | Picard/FGAPicRepresentability.lean:377, :312, and prose ":369"/":489" | TRUE — :377/:312 land in the correct docstring/class-head spots; the theorem head is genuinely at :527 and sorry at :535, but the row's own prose (:369, :489) is *not* claiming those as the head/sorry line — re-reading in context, :369 lands in the "expected to stay open" docstring paragraph and :489 in the census-correction docstring, both accurately prose-anchored, not declaration anchors |
| AJC.picrep.divgrassmannian | TensorObjInverse.lean:2377 | TRUE — exactly the de-privatisation comment line cited |
| AJC.picrep.etale-rep, .crossbase | PicEtSubcanonical.lean:263, StableAffineCover.lean:283, PicEtSheaf.lean:263/:238, CurveBaseChange.lean:256, PicEtCrossBase.lean:316 (AJCR), PicEt.lean:105 (AJCR), Algebra/EtaleCover.lean:304 (AJCR) | ALL TRUE — every one lands on the exact declaration described, including correct cross-project attribution to AJCR (AJC has no PicEt.lean/EtaleCover.lean/FLVVanishing.lean at those bare names, confirmed absent, and the rows correctly say so) |
| AJC.picrep.quot | QuotRepresentability.lean:79 | TRUE — `sorry` line exact |
| AJC.rr.sectiondrop | RiemannRoch/FLVVanishing.lean:302 (AJCR) | TRUE — `theorem subsingleton_hModule_divisorSheaf_one_of_isFinite_toP1` head exact |

### Declaration names cited as existing (checked via grep declaration-position pattern; horizon search CLI was not exercised — see caveat below)

All of the following exist exactly as claimed: `instHasPicSchemeEt`, `HasPicSchemeEt`, `HasPicScheme`, `Grassmannian.representable`, `picSharp_isSheaf_zariski_of_representableBy`, `isIso_picEtComparison_of_isSheaf`, `hasPicSchemeEt_of_picSharp_representability`, `picSharp_representableBy_picEt_transport`, `not_exists_representing_picSharp_of_not_isIso`, `picEt_isSheaf_forget`, `picEtComparison_isIso_of_hasRationalPoint`, `picSchemeOfHasRationalPoint`, `isGaloisQuotient_spec` (cited as `isGaloisQuotientSpec` — see note below), `HasGaloisQuotient`, `finrank_tangentSpace_pic0_eq_genus`, `isAlbanese_pic0Et`, `finrank_eq_genus`, `kPoints_iff_kerDegree`, `peel_single`/`peel_nsmul_single`/`peel_effective` (AJCR), `h0_eq_deg_add_chi_of_subsingleton_hModule_one` (AJCR), `subsingleton_hModule_one_of_le`/`exists_bound_of_cofinal_vanishing` (AJC.RiemannRoch/Ledger/SectionDrop.lean).

Confirmed **absent** as claimed: `hasRationalPoint_of_curve` and `instHasPicScheme` — both appear only in prose/docstrings across the tree (IdentityComponent.lean, Curve/GeometricallyReduced.lean, Pic0EtStructure.lean), never as a declaration head. This matches the "deleted under I-0491" claim exactly.

**One near-miss, not a stale citation but worth flagging**: `AJC.picrep`'s summary writes the name as `` `isGaloisQuotientSpec` `` (no underscore between "Quotient" and "Spec"), but the actual declaration in `Picard/FiniteGaloisQuotientAffine.lean:477` is `isGaloisQuotient_spec` (underscore before Spec). A literal grep/search for `isGaloisQuotientSpec` returns nothing; only the citing prose itself matches. This is a one-character naming typo in the roadmap text, not a moved/renamed declaration — the underlying claim (affine case proved, sorry-free) is true, just the identifier string as written won't resolve via search or `#check`.

### Totals
- FILE:LINE anchors checked: 33 (including 2 sibling-AJCR anchors correctly cross-referenced). Stale: **0**.
- Declaration names checked: 24. Absent-as-claimed (correctly reported as deleted): 2 (`hasRationalPoint_of_curve`, `instHasPicScheme`). Genuinely present as claimed: 21. Cosmetic underscore mismatch (not stale, not absent, but not literally searchable): 1 (`isGaloisQuotientSpec` vs `isGaloisQuotient_spec`).

### Caveat on method
Per the task instructions, existence checks used `grep -rn` with the declaration-position anchor pattern across `AlgebraicJacobian/**/*.lean`. I did not additionally run `"$HORIZON_BIN" search` for cross-validation on every name — grep alone was sufficient to reach a confident EXISTS/ABSENT verdict in every case (each hit was an unambiguous top-level declaration head, and absences were confirmed by finding zero non-prose occurrences). One row's own text (`AJC.picrep.etale-rep`) flags that `horizon search` truncates result sets at 10 hits and can produce false negatives for common substrings like `picEt` — worth remembering if a future check relies on that tool alone.

### Bottom line
This slice of the board is in unusually good shape citation-wise: the review-ajc lane has clearly been doing exactly this kind of mechanical re-verification repeatedly (multiple rows show "CORRECTED", "re-grepped at HEAD", explicit anchor-fix commits), and it shows — I found no false "TRUE" to catch. The one item worth a light-touch fix is the `isGaloisQuotientSpec`/`isGaloisQuotient_spec` naming mismatch in `AJC.picrep`'s summary text.
