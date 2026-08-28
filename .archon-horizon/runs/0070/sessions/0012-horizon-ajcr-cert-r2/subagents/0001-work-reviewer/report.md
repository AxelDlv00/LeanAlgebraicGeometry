Verdict: **converging on mathematics, but the round's claims outrun its evidence.** The transcription is real work, correctly targeted, and one claim in the spec is false at HEAD.

## 1. Is it green? — NOT ESTABLISHED. No kernel evidence exists for any of the four modules.

CONFIRMED:
- Your build ended `EXIT=124`. `/tmp/claude-1001/.../tasks/bvy1jgpqa.output` contains exactly: `ACQUIRED after 272s`, `Terminated  timeout 3300 lake build ...DivisorFamilyAffFunctorCompare`, `EXIT=124`. The 3300s cap killed it; it had not finished `DivisorFamilyAffMapKit` after ~55 min.
- No oleans for `DivisorFamilyAffMapKit`, `DivisorFamilyAffMap`, `DivisorFamilyAffFunctorCompare`, `DivRepGlobalAffLift` under `.lake/build/lib/lean/AlgebraicJacobian/Picard/`.
- The session's per-file fallback failed **environmentally**, not on a proof: task `bd2sak3vj` reports `DivisorFamilyAffMapKit.lean:6:0: error: object file ... DivisorFamilyEpsNaturality.olean ... does not exist`.
- Closure is incomplete on disk: `DivRepGlobalAffLift` needs 327 AlgebraicJacobian modules; 9 have no olean, and 5–6 of those are non-Aff modules other lanes invalidated (`GluedSheafTermBaseChangeEquiv`, `DivSchemeAdaptationFibreRegular`, `DivSchemeClassify`, `DivisorFamilyMapAlg`, `DivisorThetaSurjectivity`, `RelPicCoverInjective`).
- I launched `lake build ...DivRepGlobalAffLift` under the mkdir protocol; it sat in the lock queue for 42 min behind another lane's `charts_build.sh` (pid 1379375) and produced zero bytes. I stopped it and left that lane's lock untouched.

The `n`-explicit hazard is live and correctly documented: `DivisorFamilyAffMapKit.lean:96` passes `n` first (`DivFamZarAff.eq_of_away_eq n (fun r ...)`), `DivisorFamilyZarMapKit.lean:54` does not. So "zero sorries" here is worth nothing, exactly as you said. Filed as **I-0675**.

## 2. Advertised declarations — ALL 25 EXIST. CONFIRMED.

Every name in the four module headers and in spec §9.1 resolves to a declaration in the stated file, checked by declaration-keyword grep. No phantoms this round. Every lemma the proofs cite also exists (`Scheme.exists_basic_subcover` at `PicEtMapToolkit.lean:45`, `Over.isScalarTower_sections_basicOpen`, `DivFamZar.toAff_mapAlgHom` at `DivisorFamilyAffFace.lean:181`, `iSup_basicOpen_of_span_eq_top`).

## 3. Consumer claim — the island IS broken, and the spec says it is not. CONFIRMED DEFECT.

The measurement is right in both directions. At `1e571f4f5^` (`57eb2b87f`), zero files outside `Picard/DivisorFamilyAff*` matched the widened names with the `divFamZarAffineEquiv` collision excluded; at HEAD, exactly one does — `DivRepGlobalAffLift.lean`.

But **spec-dd-r.md §9.4 (lines 1494–1499) asserts the opposite as BINDING**, and it was never amended:

> `DivFamZarAff` / `divFamZarAff` / `divFunctorAff` appear in **zero** Lean files outside the `Picard/DivisorFamilyAff*.lean` family. … The widened layer is still an **island** … no consumer has been restated.

`cf87b8c61` (the addendum) landed 00:53:52; `1e571f4f5` (the file that falsifies it) landed 00:55:34. And `grep -c "DivRepGlobalAffLift\|pullGlobalAff" informal/spec-dd-r.md` = **0** — §9.1's "what landed" manifest omits the fourth file and all four of its declarations. The roadmap node has the corrected version; the spec does not. Filed as **I-0674**, with the durable lesson as **I-0676**.

On non-vacuity of `pullGlobalAff_comp`: it is **not** vacuous or degenerate. `pullGlobalAff := divFamZarToAffVehicle ∘ pullGlobal`, and the theorem equates it with `divFamZarAff.map C g f (...)` — the glued restriction whose value at a straddling `W` is genuinely assembled by `exists_glue_of_basic_compat`, not a projection. Its proof (`DivRepGlobalAffLift.lean:146-149`) is two rewrites, `pullGlobal_comp` then `divFamZarToAffVehicle_map`, and the second is the real content: `divFamZarToAffVehicle_map` (`AffFunctorCompare.lean:70`) is proved through widened uniqueness `divFamZarAff.mapVal_eq_of`, so the equation does constrain the widened `map`. It is a cheap corollary of substantive predecessor work, which is what the file claims.

The honest caveat, which the file does state: this is a push-forward, not representability. There is no `toGlobalDataAff`, no `DivRepGlobalData` on the widened side, and no `RepresentableBy divFunctorAff` — grepped, all absent. `divFunctorAff` has **zero** consumers outside its two defining files.

## 4. Over-strong claims

(a) **Legitimate.** CONFIRMED as a transcription: a mechanical decl-level diff of `AffMapKit` vs `ZarMapKit` and `AffMap` vs `ZarMap` shows identical declaration sequences and near-identical proof scripts, differing only by carrier name, the `π`/`IsAffineHom` binder dropping out, `[IsProper C.hom]` appearing, the explicit `n`, and the three genuinely new declarations (`divFunctorAff` and its two simp lemmas).

(b) **CONFIRMED by measurement.** I computed the full 327-module import closure of `DivRepGlobalAffLift` and grepped every file for `Infinite`/`Fintype k`/`Nat.card`/`ncard`/cardinality bounds: nothing. The only `[Infinite k]` in `Picard/` is `DivSchemeCertZarFibreAvoid.lean:270,343`, which is **not** in the closure. Also confirmed clean on I-0492 clause 3: `DivSchemeCertZarSwallow`, `DivSchemeCertZarConn`, `DivSchemeCertZarChartTrace` and `DivisorFamily.` are all absent from all three new closures, so the refuted partition machinery is not reachable.

(c) **PLAUSIBLE, with a scope caveat.** The lane's certificate residue is genuinely one statement — the `0B8B` input, visible as `hWle : W ≤ (D.localEquations hD).cover.opens z₀` at `DivisorFamilyAffSeedEndpoint.lean:82`. But `exists_isCertified_of_seed_of_swallowing_affineOpen` also takes `hrank` (the degree datum) and `[IsNoetherianRing R]`; the spec argues `hrank` is not a *missing* input but the content of "degree n", which is defensible. Note the lane's parent node still lists `away-kerspan` as `blocked` (unblocked only for R2's covers).

(d) **OVER-STRONG.** Three places — `DivisorFamilyAffFunctorCompare.lean:33-36`, `DivRepGlobalAffLift.lean:35-37`, spec §9.3 — say the straddling witness means "no natural transformation back can exist". ADDENDUM 4 §4.3 shows `DivFamZar.toAff` is not surjective, which refutes an **inverse or section**, not the existence of some transformation `divFunctorAff ⟶ divFunctor`. The witness also needs a specific genus-≥2 curve, while the docstrings state it unconditionally for a variable `C`. Nothing consumes the negative claim, so this is precision, not a blocker. Noted on I-0674.

## 5. Smuggled chart typing — NO. CONFIRMED legitimate.

`[IsAffineHom pi]` at `DivRepGlobalAffLift.lean:103` sits on the **input** side: `pullGlobalAff`'s body calls the chart-typed `pullGlobal` and pushes it through `divFamZarToAffVehicle C g pi`, both of which require it. The **conclusion type is `divFamZarAff C g T`** — no `pi`, no chart index. Neither `DivisorFamilyAffMap.lean` nor `DivisorFamilyAffMapKit.lean` mentions `IsAffineHom` at all, and no partition-of-unity name appears anywhere in the diff.

## Bottom line

Real throughput: ~900 lines closing a residue item the lane had carried for four sessions, with the last packaging layer and one consumer. No sorries, no axioms, no artificial disjunctions, no chart leak. The failure mode is the one this lane keeps repeating — **prose claims committed ahead of the evidence**: a BINDING spec paragraph that its own next commit falsified, a manifest missing the file that mattered, and four rooted modules whose only kernel check timed out. Two mechanical fixes (amend §9.1/§9.4, weaken the converse claim) and one build.

Files: `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/{DivisorFamilyAffMapKit,DivisorFamilyAffMap,DivisorFamilyAffFunctorCompare,DivRepGlobalAffLift}.lean`, `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/informal/spec-dd-r.md` (§9.1 lines 1431–1450, §9.4 lines 1488–1510). Inbox: I-0674 (issue, spec), I-0675 (issue, unverified build), I-0676 (memory).
