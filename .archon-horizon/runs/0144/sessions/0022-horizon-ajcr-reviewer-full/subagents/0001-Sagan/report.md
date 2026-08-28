Audited and reported to `/root`:

- `Pic0RankOneCanonicalEvaluation.lean` already contains the complete family-level construction using the real `canonicalRankOneDivisorOfMem`, including naturality, representer transport, and `canonicalRankOneEvaluationDivisorData`.
- Identified and communicated the two required fixes: use `Iso.inv_hom_id_app_apply` at the representer preimage boundaries, not `hom_inv_id_app_apply`.
- Confirmed the corrected coercion pattern in `/tmp/RepresenterCoercion.lean`.
- No production files were edited or committed in this lane.
- The prerequisite `Pic0RankOneCanonicalDivisorFree` compilation remained CPU-bound without producing an `.olean`; this was reported as the remaining verification blocker.
