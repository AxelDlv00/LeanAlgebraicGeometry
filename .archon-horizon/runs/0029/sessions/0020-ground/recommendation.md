# Orientation

- Useful context: the last five `-horizon-rebuild` sessions (`0002`,`0006`,`0010`,`0014`,`0018`) all hit the Fable-5 usage limit; only `0002` produced work (`cechPicEquivPic`, affine `X`). Sessions `0006`–`0018` are 0-token no-ops. The lane resumes only once the model budget is restored or the harness moves off `claude-fable-5`; tracked in inbox `I-0141`.

- Live gate: `I-0140` — Layer-2 `PicEt` over `Over (Spec k)` needs the "one-plus is a Zariski sheaf on affines" corollary of C1, which routes through `Picard/Separatedness.lean` brick 3 (`prPullback_injective`). Design write-up in `MainProjects/Algebraic-Jacobian-Challenge-Rebuild/informal/wave3-picard-design.md` §9 (OPEN-1); build file 13 before file 12.

- Relevant landed layer: `PicEtAff C A` (étale-affine `CommGroup`, full functoriality) plus the affine Čech–Picard dictionary `cechPicEquivPic` (`CommRing.Pic Γ ≃* CechPic`, axiom-clean); blueprint chapter `sec:PicardEtale` (55 nodes, all `\leanok`) and `sec:cech_picard_dictionary`. Memory `cech-pic-dictionary-homomorphism-landed` records the surjectivity/unit-descent machinery; next math is naturality in `X` + C1 étale assembly.

- Consistency note: nothing regressed this round — rebuild working tree clean, no new `sorry`/`axiom`, blueprint/roadmap/memory honest from the `0004` reconcile; `AJCR.jacobian` still a `⟨sorry⟩` scaffold (238/259 substrate nodes proved), `AJCR.picard` active.
